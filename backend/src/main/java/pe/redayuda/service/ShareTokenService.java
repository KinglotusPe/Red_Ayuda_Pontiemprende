package pe.redayuda.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.redayuda.dto.PublicEmergencyShareDto;
import pe.redayuda.entity.*;
import pe.redayuda.exception.BadRequestException;
import pe.redayuda.exception.ResourceNotFoundException;
import pe.redayuda.repository.*;
import pe.redayuda.storage.AudioStorageService;

import java.security.SecureRandom;
import java.time.OffsetDateTime;
import java.util.HexFormat;
import java.util.Optional;
import java.util.UUID;

@Service
public class ShareTokenService {

    private final EmergencyShareTokenRepository shareTokenRepository;
    private final EmergenciaUbicacionRepository ubicacionRepository;
    private final EmergenciaAudioRepository audioRepository;
    private final AudioStorageService audioStorageService;
    private final DirectorioEmergenciaRepository directorioRepository;
    private final DirectoryService directoryService;

    @Value("${app.base-url:http://localhost:8080}")
    private String baseUrl;

    @Value("${app.security.share-token-expiration-hours:24}")
    private int expirationHours;

    public ShareTokenService(
            EmergencyShareTokenRepository shareTokenRepository,
            EmergenciaUbicacionRepository ubicacionRepository,
            EmergenciaAudioRepository audioRepository,
            AudioStorageService audioStorageService,
            DirectorioEmergenciaRepository directorioRepository,
            DirectoryService directoryService) {
        this.shareTokenRepository = shareTokenRepository;
        this.ubicacionRepository = ubicacionRepository;
        this.audioRepository = audioRepository;
        this.audioStorageService = audioStorageService;
        this.directorioRepository = directorioRepository;
        this.directoryService = directoryService;
    }

    @Transactional
    public EmergencyShareToken createShareToken(Emergencia emergencia, ContactoConfianza contacto, boolean permiteUbicacionPrecisa, boolean permiteAudio) {
        byte[] randomBytes = new byte[32];
        new SecureRandom().nextBytes(randomBytes);
        String tokenString = HexFormat.of().formatHex(randomBytes);

        EmergencyShareToken token = new EmergencyShareToken();
        token.setToken(tokenString);
        token.setEmergencia(emergencia);
        token.setContacto(contacto);
        token.setPermiteUbicacionPrecisa(permiteUbicacionPrecisa);
        token.setPermiteAudio(permiteAudio);
        token.setExpiraEn(OffsetDateTime.now().plusHours(expirationHours));
        token.setRevocado(false);

        return shareTokenRepository.save(token);
    }

    public String buildShareUrl(String tokenString) {
        return baseUrl + "/emergency/share/" + tokenString;
    }

    @Transactional(readOnly = true)
    public PublicEmergencyShareDto getEmergencyByShareToken(String tokenString) {
        EmergencyShareToken token = shareTokenRepository.findByToken(tokenString)
                .orElseThrow(() -> new ResourceNotFoundException("Enlace de seguimiento de emergencia no encontrado o inválido"));

        if (!token.isValido()) {
            throw new BadRequestException("Este enlace de seguimiento ha expirado o ha sido revocado por razones de seguridad");
        }

        Emergencia emergencia = token.getEmergencia();
        Usuario victima = emergencia.getUsuario();

        PublicEmergencyShareDto dto = new PublicEmergencyShareDto();
        dto.setEmergenciaId(emergencia.getId());
        dto.setNombreVictima(victima.getNombres() + " " + victima.getApellidos());
        dto.setTipo(emergencia.getTipo());
        dto.setEstado(emergencia.getEstado());
        dto.setFechaInicio(emergencia.getFechaInicio());
        dto.setNivelBateria(emergencia.getNivelBateria());
        dto.setDispositivoOffline(emergencia.getDispositivoOffline());

        // Obtener última ubicación registrada
        Optional<EmergenciaUbicacion> ultimaUbicacion = ubicacionRepository.findFirstByEmergenciaIdOrderByTimestampDesc(emergencia.getId());
        if (ultimaUbicacion.isPresent()) {
            EmergenciaUbicacion loc = ultimaUbicacion.get();
            if (Boolean.TRUE.equals(token.getPermiteUbicacionPrecisa())) {
                dto.setLatitud(loc.getLatitud());
                dto.setLongitud(loc.getLongitud());
                dto.setPrecisionMetros(loc.getPrecisionMetros());
            } else {
                // Ofuscación controlada si no tiene permiso de ubicación precisa: redondear a ~500m
                dto.setLatitud(Math.round(loc.getLatitud() * 100.0) / 100.0);
                dto.setLongitud(Math.round(loc.getLongitud() * 100.0) / 100.0);
                dto.setPrecisionMetros(500.0);
            }
            dto.setFuente(loc.getFuente());
            dto.setUltimaActualizacion(loc.getTimestamp());
        }

        // Obtener audio si está autorizado
        if (Boolean.TRUE.equals(token.getPermiteAudio())) {
            Optional<EmergenciaAudio> audioOpt = audioRepository.findFirstByEmergenciaIdOrderByFechaGrabacionDesc(emergencia.getId());
            if (audioOpt.isPresent()) {
                dto.setAudioDisponible(true);
                dto.setAudioSignedUrl(audioStorageService.generatePreSignedUrl(audioOpt.get().getStorageKey(), 15));
            } else {
                dto.setAudioDisponible(false);
            }
        } else {
            dto.setAudioDisponible(false);
        }

        // Cargar botones directos de llamadas oficiales (105, 106, 116, Serenazgo)
        dto.setServiciosEmergencia(directoryService.getDirectory("Ayacucho", null));

        return dto;
    }
}
