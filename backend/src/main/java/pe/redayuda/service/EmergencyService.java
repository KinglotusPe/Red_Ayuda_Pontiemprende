package pe.redayuda.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import pe.redayuda.dto.*;
import pe.redayuda.entity.*;
import pe.redayuda.exception.BadRequestException;
import pe.redayuda.exception.ResourceNotFoundException;
import pe.redayuda.location.GeoUtils;
import pe.redayuda.notification.NotificationBrokerService;
import pe.redayuda.notification.NotificationChannel;
import pe.redayuda.notification.NotificationMessage;
import pe.redayuda.repository.*;
import pe.redayuda.storage.AudioStorageService;
import pe.redayuda.websocket.EmergencyWebSocketService;

import java.io.IOException;
import java.time.Duration;
import java.time.OffsetDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class EmergencyService {

    private static final Logger logger = LoggerFactory.getLogger(EmergencyService.class);

    private final EmergenciaRepository emergenciaRepository;
    private final EmergenciaUbicacionRepository ubicacionRepository;
    private final EmergenciaAudioRepository audioRepository;
    private final EmergenciaEventoRepository eventoRepository;
    private final ContactoConfianzaRepository contactoRepository;
    private final UsuarioRepository usuarioRepository;
    private final ShareTokenService shareTokenService;
    private final NotificationBrokerService notificationBroker;
    private final AudioStorageService audioStorageService;
    private final EmergencyWebSocketService webSocketService;
    private final GeoUtils geoUtils;
    private final PasswordEncoder passwordEncoder;

    public EmergencyService(
            EmergenciaRepository emergenciaRepository,
            EmergenciaUbicacionRepository ubicacionRepository,
            EmergenciaAudioRepository audioRepository,
            EmergenciaEventoRepository eventoRepository,
            ContactoConfianzaRepository contactoRepository,
            UsuarioRepository usuarioRepository,
            ShareTokenService shareTokenService,
            NotificationBrokerService notificationBroker,
            AudioStorageService audioStorageService,
            EmergencyWebSocketService webSocketService,
            GeoUtils geoUtils,
            PasswordEncoder passwordEncoder) {
        this.emergenciaRepository = emergenciaRepository;
        this.ubicacionRepository = ubicacionRepository;
        this.audioRepository = audioRepository;
        this.eventoRepository = eventoRepository;
        this.contactoRepository = contactoRepository;
        this.usuarioRepository = usuarioRepository;
        this.shareTokenService = shareTokenService;
        this.notificationBroker = notificationBroker;
        this.audioStorageService = audioStorageService;
        this.webSocketService = webSocketService;
        this.geoUtils = geoUtils;
        this.passwordEncoder = passwordEncoder;
    }

    /**
     * REGLA CRÍTICA 14: Prioridad a la velocidad. Se crea inmediatamente la emergencia,
     * se registra primera ubicación, se despachan notificaciones y enlaces web a contactos.
     */
    @Transactional
    public EmergencyResponse triggerSos(UUID userId, TriggerSosRequest request) {
        Usuario usuario = usuarioRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("Usuario no encontrado"));

        // 1. Crear inmediatamente la emergencia en BD
        Emergencia emergencia = new Emergencia();
        emergencia.setUsuario(usuario);
        emergencia.setTipo(request.getTipo() != null ? request.getTipo() : "DESCONOCIDA");
        emergencia.setEstado("ACTIVA");
        emergencia.setNivelBateria(request.getNivelBateria());
        emergencia.setFechaInicio(OffsetDateTime.now());

        Emergencia savedEmergencia = emergenciaRepository.save(emergencia);

        // 2. Registrar eventos iniciales en el timeline inmutable
        recordEvent(savedEmergencia, "SOS_TRIGGERED", "Activación manual SOS por el usuario");
        recordEvent(savedEmergencia, "EMERGENCY_CREATED", "Emergencia creada y activa en el sistema");

        // 3. Registrar primera ubicación disponible (GPS, Red, Última Conocida o UNKNOWN)
        EmergenciaUbicacion primeraUbicacion = null;
        if (request.getLatitud() != null && request.getLongitud() != null) {
            primeraUbicacion = new EmergenciaUbicacion();
            primeraUbicacion.setEmergencia(savedEmergencia);
            primeraUbicacion.setLatitud(request.getLatitud());
            primeraUbicacion.setLongitud(request.getLongitud());
            primeraUbicacion.setPrecisionMetros(request.getPrecisionMetros());
            primeraUbicacion.setFuente(request.getFuente() != null ? request.getFuente() : "GPS");
            primeraUbicacion.setEsInicial(true);
            primeraUbicacion.setEsUltimaConocida(true);
            ubicacionRepository.save(primeraUbicacion);

            recordEvent(savedEmergencia, "LOCATION_RECEIVED", "Primera ubicación fijada (" + primeraUbicacion.getFuente() + ")");
        } else {
            recordEvent(savedEmergencia, "LOCATION_UNAVAILABLE", "Ubicación inicial no disponible; buscando señal");
        }

        // 4. Generar tokens de seguimiento y notificar contactos de confianza
        List<ContactoConfianza> contactos = contactoRepository.findByUsuarioIdAndActivoTrueOrderByPrioridadAsc(userId);
        for (ContactoConfianza contacto : contactos) {
            EmergencyShareToken token = shareTokenService.createShareToken(
                    savedEmergencia,
                    contacto,
                    contacto.getPermiteUbicacionPrecisa(),
                    contacto.getPermiteAudio()
            );

            String shareUrl = shareTokenService.buildShareUrl(token.getToken());

            // Enviar notificación PUSH (si tiene la app)
            if (contacto.getTieneRedAyuda() && contacto.getUsuarioRedAyuda() != null) {
                NotificationMessage pushMsg = new NotificationMessage(
                        savedEmergencia.getId(),
                        contacto.getId(),
                        contacto.getUsuarioRedAyuda().getEmail(),
                        NotificationChannel.PUSH,
                        "¡ALERTA RED AYUDA SOS!",
                        usuario.getNombres() + " necesita ayuda urgente (" + savedEmergencia.getTipo() + ")",
                        Map.of("emergencyId", savedEmergencia.getId().toString(), "shareUrl", shareUrl)
                );
                notificationBroker.dispatchEmergencyAlert(pushMsg);
            }

            // Enviar enlace por SMS (para contactos con o sin app)
            NotificationMessage smsMsg = new NotificationMessage(
                    savedEmergencia.getId(),
                    contacto.getId(),
                    contacto.getTelefono(),
                    NotificationChannel.SMS,
                    "ALERTA RED AYUDA",
                    "URGENTE: " + usuario.getNombres() + " activo alerta SOS. Siga su ubicacion en vivo aqui: " + shareUrl,
                    Map.of("shareUrl", shareUrl)
            );
            notificationBroker.dispatchEmergencyAlert(smsMsg);

            // Enviar mensaje WhatsApp
            NotificationMessage waMsg = new NotificationMessage(
                    savedEmergencia.getId(),
                    contacto.getId(),
                    contacto.getTelefono(),
                    NotificationChannel.WHATSAPP,
                    "ALERTA RED AYUDA SOS",
                    "⚠️ *RED AYUDA - ALERTA SOS*\n" + usuario.getNombres() + " ha reportado una emergencia.\nSeguimiento en tiempo real: " + shareUrl,
                    Map.of("shareUrl", shareUrl)
            );
            notificationBroker.dispatchEmergencyAlert(waMsg);

            recordEvent(savedEmergencia, "CONTACT_NOTIFIED", "Contacto avisado: " + contacto.getNombre());
        }

        // 5. Difundir por WebSocket a clientes y panel administrativo
        EmergencyResponse response = buildResponse(savedEmergencia, primeraUbicacion);
        webSocketService.broadcastEmergencyUpdate(savedEmergencia.getId(), response);
        webSocketService.broadcastAdminAlert(response);

        // 6. Notificar radar a usuarios cercanos de forma anónima
        if (primeraUbicacion != null) {
            NearbyAlertDto nearbyAlert = new NearbyAlertDto(
                    savedEmergencia.getId(),
                    savedEmergencia.getTipo(),
                    0.0,
                    "Zona Ayacucho Centro",
                    savedEmergencia.getFechaInicio(),
                    savedEmergencia.getEstado()
            );
            webSocketService.broadcastRadarAlert("ayacucho_central", nearbyAlert);
            recordEvent(savedEmergencia, "NEARBY_USERS_NOTIFIED", "Difusión preventiva en radar a usuarios cercanos");
        }

        return response;
    }

    /**
     * Actualización periódica de coordenadas de tracking.
     */
    @Transactional
    public EmergencyResponse updateLocation(UUID emergencyId, LocationUpdateRequest request) {
        Emergencia emergencia = emergenciaRepository.findById(emergencyId)
                .orElseThrow(() -> new ResourceNotFoundException("Emergencia no encontrada"));

        if (!"ACTIVA".equalsIgnoreCase(emergencia.getEstado()) && !"CREADA".equalsIgnoreCase(emergencia.getEstado())) {
            throw new BadRequestException("La emergencia ya no está activa");
        }

        // Buscar última ubicación para calcular movimiento y mejora de precisión
        Optional<EmergenciaUbicacion> ultimaOpt = ubicacionRepository.findFirstByEmergenciaIdOrderByTimestampDesc(emergencyId);

        String estadoMovimiento = "QUIETO";
        Double velocidad = request.getVelocidadKmh();
        boolean isAccuracyImproved = false;

        if (ultimaOpt.isPresent()) {
            EmergenciaUbicacion prev = ultimaOpt.get();
            double distanceMeters = geoUtils.calculateDistanceMeters(
                    prev.getLatitud(), prev.getLongitud(),
                    request.getLatitud(), request.getLongitud()
            );

            long seconds = Duration.between(prev.getTimestamp(), OffsetDateTime.now()).getSeconds();
            estadoMovimiento = geoUtils.determineMovementState(distanceMeters, seconds);

            isAccuracyImproved = geoUtils.isSignificantAccuracyImprovement(prev.getPrecisionMetros(), request.getPrecisionMetros());

            // Marcar la anterior como no última
            prev.setEsUltimaConocida(false);
            ubicacionRepository.save(prev);
        }

        EmergenciaUbicacion nuevaUbicacion = new EmergenciaUbicacion();
        nuevaUbicacion.setEmergencia(emergencia);
        nuevaUbicacion.setLatitud(request.getLatitud());
        nuevaUbicacion.setLongitud(request.getLongitud());
        nuevaUbicacion.setPrecisionMetros(request.getPrecisionMetros());
        nuevaUbicacion.setFuente(request.getFuente() != null ? request.getFuente() : "GPS");
        nuevaUbicacion.setEstadoMovimiento(estadoMovimiento);
        nuevaUbicacion.setVelocidadKmh(velocidad);
        nuevaUbicacion.setEsUltimaConocida(true);
        ubicacionRepository.save(nuevaUbicacion);

        if (isAccuracyImproved) {
            recordEvent(emergencia, "LOCATION_IMPROVED", "Precisión mejorada a " + request.getPrecisionMetros() + "m");
        }

        if (request.getNivelBateria() != null) {
            emergencia.setNivelBateria(request.getNivelBateria());
            if (request.getNivelBateria() <= 15) {
                recordEvent(emergencia, "BATTERY_LOW", "Nivel de batería crítico: " + request.getNivelBateria() + "%");
            }
            emergenciaRepository.save(emergencia);
        }

        EmergencyResponse response = buildResponse(emergencia, nuevaUbicacion);
        webSocketService.broadcastEmergencyUpdate(emergencia.getId(), response);

        return response;
    }

    /**
     * Subida de audio de emergencia capturado tras activarse el SOS (5 a 10s).
     */
    @Transactional
    public void uploadAudio(UUID emergencyId, MultipartFile file, int duracionSegundos) throws IOException {
        Emergencia emergencia = emergenciaRepository.findById(emergencyId)
                .orElseThrow(() -> new ResourceNotFoundException("Emergencia no encontrada"));

        String storageKey = audioStorageService.uploadAudio(emergencyId.toString(), file);

        EmergenciaAudio audio = new EmergenciaAudio();
        audio.setEmergencia(emergencia);
        audio.setStorageKey(storageKey);
        audio.setDuracionSegundos(duracionSegundos);
        audio.setTamanoBytes(file.getSize());
        audio.setFormato(file.getContentType() != null ? file.getContentType() : "audio/aac");
        audio.setEstadoSubida("SUBIDO");
        audioRepository.save(audio);

        recordEvent(emergencia, "AUDIO_CAPTURED", "Audio ambiente de emergencia capturado");
        recordEvent(emergencia, "AUDIO_UPLOADED", "Audio subido a almacenamiento privado seguro");

        // Emitir actualización por WebSocket a contactos
        webSocketService.broadcastEmergencyUpdate(emergencia.getId(), Map.of(
                "evento", "AUDIO_AVAILABLE",
                "emergencyId", emergencia.getId().toString()
        ));
    }

    /**
     * SECCIÓN 13: Cancelación segura mediante PIN.
     * Evalúa PIN normal vs PIN de coacción.
     */
    @Transactional
    public Map<String, Object> cancelEmergency(UUID emergencyId, UUID userId, CancelEmergencyRequest request) {
        Emergencia emergencia = emergenciaRepository.findById(emergencyId)
                .orElseThrow(() -> new ResourceNotFoundException("Emergencia no encontrada"));

        Usuario usuario = usuarioRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("Usuario no encontrado"));

        String inputPin = request.getPin();

        // 1. Comprobar si coincide con el PIN DE COACCIÓN
        if (usuario.getPinCoercionHash() != null && passwordEncoder.matches(inputPin, usuario.getPinCoercionHash())) {
            logger.warn("¡ALERTA CRÍTICA: PIN DE COACCIÓN UTILIZADO EN EMERGENCIA {}!", emergencyId);

            // MANTENER LA EMERGENCIA ACTIVA
            emergencia.setPosibleCoaccion(true);
            emergenciaRepository.save(emergencia);

            recordEvent(emergencia, "COERCION_PIN_USED", "¡PIN DE COACCIÓN INTRODUCIDO! Emergencia continúa en curso");

            // Enviar alerta discreta a contactos
            List<ContactoConfianza> contactos = contactoRepository.findByUsuarioIdAndActivoTrueOrderByPrioridadAsc(userId);
            for (ContactoConfianza contacto : contactos) {
                NotificationMessage alertMsg = new NotificationMessage(
                        emergencia.getId(),
                        contacto.getId(),
                        contacto.getTelefono(),
                        NotificationChannel.SMS,
                        "ALERTA SILENCIOSA DE SEGURIDAD",
                        "ALERTA CRÍTICA: Posible coacción detectada en emergencia de " + usuario.getNombres() + ". La alerta permanece ACTIVA.",
                        Map.of("coercion", "true")
                );
                notificationBroker.dispatchEmergencyAlert(alertMsg);
            }

            // Para la aplicación móvil del usuario se retorna éxito simulado para despistar al agresor
            Map<String, Object> result = new HashMap<>();
            result.put("mensaje", "Emergencia cancelada exitosamente");
            result.put("estado", "CANCELADA"); // Aparenta cancelación ante el agresor
            result.put("coaccionDetectada", true); // Flag interno
            return result;
        }

        // 2. Comprobar PIN NORMAL
        if (usuario.getPinHash() != null && passwordEncoder.matches(inputPin, usuario.getPinHash())) {
            emergencia.setEstado("CANCELADA");
            emergencia.setMotivoCancelacion(request.getMotivo() != null ? request.getMotivo() : "Cancelada voluntariamente con PIN normal");
            emergencia.setCanceladoPor(usuario);
            emergencia.setFechaCierre(OffsetDateTime.now());
            emergenciaRepository.save(emergencia);

            recordEvent(emergencia, "STATUS_CHANGED", "Estado cambiado a CANCELADA con PIN normal");
            recordEvent(emergencia, "EMERGENCY_FINISHED", "Emergencia concluida correctamente");

            webSocketService.broadcastEmergencyUpdate(emergencia.getId(), Map.of(
                    "evento", "EMERGENCY_CANCELLED",
                    "emergencyId", emergencia.getId().toString()
            ));

            Map<String, Object> result = new HashMap<>();
            result.put("mensaje", "Emergencia cancelada exitosamente");
            result.put("estado", "CANCELADA");
            result.put("coaccionDetectada", false);
            return result;
        }

        // 3. PIN inválido
        recordEvent(emergencia, "CANCEL_ATTEMPT_FAILED", "Intento fallido de cancelación con PIN erróneo");
        throw new BadRequestException("PIN de seguridad incorrecto. La emergencia continúa activa.");
    }

    @Transactional
    public EmergencyResponse resolveEmergency(UUID emergencyId, UUID userId) {
        Emergencia emergencia = emergenciaRepository.findById(emergencyId)
                .orElseThrow(() -> new ResourceNotFoundException("Emergencia no encontrada"));

        emergencia.setEstado("RESUELTA");
        emergencia.setFechaCierre(OffsetDateTime.now());
        emergenciaRepository.save(emergencia);

        recordEvent(emergencia, "STATUS_CHANGED", "Emergencia marcada como RESUELTA");
        recordEvent(emergencia, "EMERGENCY_FINISHED", "Emergencia finalizada con éxito");

        EmergencyResponse response = buildResponse(emergencia, null);
        webSocketService.broadcastEmergencyUpdate(emergencia.getId(), response);
        return response;
    }

    @Transactional(readOnly = true)
    public EmergencyResponse getEmergencyDetail(UUID emergencyId, UUID userId) {
        Emergencia emergencia = emergenciaRepository.findById(emergencyId)
                .orElseThrow(() -> new ResourceNotFoundException("Emergencia no encontrada"));

        return buildResponse(emergencia, null);
    }

    @Transactional(readOnly = true)
    public List<EmergencyResponse> getUserEmergencies(UUID userId) {
        return emergenciaRepository.findByUsuarioIdOrderByFechaInicioDesc(userId).stream()
                .map(e -> buildResponse(e, null))
                .collect(Collectors.toList());
    }

    private void recordEvent(Emergencia emergencia, String tipoEvento, String metadata) {
        EmergenciaEvento evento = new EmergenciaEvento(emergencia, tipoEvento, metadata);
        eventoRepository.save(evento);
    }

    private EmergencyResponse buildResponse(Emergencia emergencia, EmergenciaUbicacion ubicacionOpt) {
        EmergencyResponse r = new EmergencyResponse();
        r.setId(emergencia.getId());
        r.setUsuarioId(emergencia.getUsuario().getId());
        r.setUsuarioNombre(emergencia.getUsuario().getNombres() + " " + emergencia.getUsuario().getApellidos());
        r.setTipo(emergencia.getTipo());
        r.setEstado(emergencia.getEstado());
        r.setPosibleCoaccion(emergencia.getPosibleCoaccion());
        r.setNivelBateria(emergencia.getNivelBateria());
        r.setDispositivoOffline(emergencia.getDispositivoOffline());
        r.setFechaInicio(emergencia.getFechaInicio());
        r.setFechaCierre(emergencia.getFechaCierre());

        EmergenciaUbicacion loc = ubicacionOpt != null ? ubicacionOpt :
                ubicacionRepository.findFirstByEmergenciaIdOrderByTimestampDesc(emergencia.getId()).orElse(null);

        if (loc != null) {
            r.setUltimaUbicacion(new EmergencyResponse.LocationDto(
                    loc.getLatitud(),
                    loc.getLongitud(),
                    loc.getPrecisionMetros(),
                    loc.getFuente(),
                    loc.getEstadoMovimiento(),
                    loc.getVelocidadKmh(),
                    loc.getTimestamp()
            ));
        }

        List<EmergenciaEvento> eventos = eventoRepository.findByEmergenciaIdOrderByTimestampAsc(emergencia.getId());
        r.setEventos(eventos.stream()
                .map(ev -> new EmergencyResponse.EventDto(ev.getTipoEvento(), ev.getMetadataJson(), ev.getTimestamp()))
                .collect(Collectors.toList()));

        // Obtener audio firmado si existe
        audioRepository.findFirstByEmergenciaIdOrderByFechaGrabacionDesc(emergencia.getId()).ifPresent(audio -> {
            r.setAudioSignedUrl(audioStorageService.generatePreSignedUrl(audio.getStorageKey(), 15));
        });

        return r;
    }
}
