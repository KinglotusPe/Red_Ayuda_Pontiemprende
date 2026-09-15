package pe.redayuda;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.password.PasswordEncoder;
import pe.redayuda.dto.CancelEmergencyRequest;
import pe.redayuda.dto.EmergencyResponse;
import pe.redayuda.dto.TriggerSosRequest;
import pe.redayuda.entity.*;
import pe.redayuda.exception.BadRequestException;
import pe.redayuda.location.GeoUtils;
import pe.redayuda.notification.NotificationBrokerService;
import pe.redayuda.repository.*;
import pe.redayuda.service.EmergencyService;
import pe.redayuda.service.ShareTokenService;
import pe.redayuda.storage.AudioStorageService;
import pe.redayuda.websocket.EmergencyWebSocketService;

import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class EmergencyServiceTest {

    @Mock private EmergenciaRepository emergenciaRepository;
    @Mock private EmergenciaUbicacionRepository ubicacionRepository;
    @Mock private EmergenciaAudioRepository audioRepository;
    @Mock private EmergenciaEventoRepository eventoRepository;
    @Mock private ContactoConfianzaRepository contactoRepository;
    @Mock private UsuarioRepository usuarioRepository;
    @Mock private ShareTokenService shareTokenService;
    @Mock private NotificationBrokerService notificationBroker;
    @Mock private AudioStorageService audioStorageService;
    @Mock private EmergencyWebSocketService webSocketService;
    @Mock private GeoUtils geoUtils;
    @Mock private PasswordEncoder passwordEncoder;

    @InjectMocks
    private EmergencyService emergencyService;

    private Usuario mockUser;
    private Emergencia mockEmergency;
    private UUID userId;
    private UUID emergencyId;

    @BeforeEach
    void setUp() {
        userId = UUID.randomUUID();
        emergencyId = UUID.randomUUID();

        mockUser = new Usuario();
        mockUser.setId(userId);
        mockUser.setNombres("Carlos");
        mockUser.setApellidos("Mendoza");
        mockUser.setEmail("carlos@redayuda.pe");
        mockUser.setPinHash("hashed_normal_pin");
        mockUser.setPinCoercionHash("hashed_coercion_pin");

        mockEmergency = new Emergencia();
        mockEmergency.setId(emergencyId);
        mockEmergency.setUsuario(mockUser);
        mockEmergency.setTipo("ROBO");
        mockEmergency.setEstado("ACTIVA");
    }

    @Test
    void testTriggerSosCreatesEmergencyImmediately() {
        TriggerSosRequest req = new TriggerSosRequest();
        req.setTipo("AGRESION");
        req.setLatitud(-13.1631);
        req.setLongitud(-74.2236);
        req.setPrecisionMetros(15.0);
        req.setNivelBateria(85);

        when(usuarioRepository.findById(userId)).thenReturn(Optional.of(mockUser));
        when(emergenciaRepository.save(any(Emergencia.class))).thenAnswer(invocation -> {
            Emergencia e = invocation.getArgument(0);
            e.setId(emergencyId);
            return e;
        });
        when(contactoRepository.findByUsuarioIdAndActivoTrueOrderByPrioridadAsc(userId)).thenReturn(Collections.emptyList());

        EmergencyResponse response = emergencyService.triggerSos(userId, req);

        assertNotNull(response);
        assertEquals("ACTIVA", response.getEstado());
        assertEquals("AGRESION", response.getTipo());
        verify(emergenciaRepository, times(1)).save(any(Emergencia.class));
        verify(eventoRepository, atLeast(2)).save(any(EmergenciaEvento.class));
    }

    @Test
    void testCancelWithNormalPinCancelsEmergency() {
        CancelEmergencyRequest req = new CancelEmergencyRequest();
        req.setPin("1234");
        req.setMotivo("Error al manipular el teléfono");

        when(emergenciaRepository.findById(emergencyId)).thenReturn(Optional.of(mockEmergency));
        when(usuarioRepository.findById(userId)).thenReturn(Optional.of(mockUser));
        when(passwordEncoder.matches("1234", "hashed_coercion_pin")).thenReturn(false);
        when(passwordEncoder.matches("1234", "hashed_normal_pin")).thenReturn(true);

        Map<String, Object> result = emergencyService.cancelEmergency(emergencyId, userId, req);

        assertEquals("CANCELADA", result.get("estado"));
        assertEquals(false, result.get("coaccionDetectada"));
        assertEquals("CANCELADA", mockEmergency.getEstado());
        verify(emergenciaRepository).save(mockEmergency);
    }

    @Test
    void testCancelWithCoercionPinKeepsEmergencyActiveAndSetsCoercionFlag() {
        CancelEmergencyRequest req = new CancelEmergencyRequest();
        req.setPin("9999"); // PIN de coacción

        when(emergenciaRepository.findById(emergencyId)).thenReturn(Optional.of(mockEmergency));
        when(usuarioRepository.findById(userId)).thenReturn(Optional.of(mockUser));
        when(passwordEncoder.matches("9999", "hashed_coercion_pin")).thenReturn(true);
        when(contactoRepository.findByUsuarioIdAndActivoTrueOrderByPrioridadAsc(userId)).thenReturn(Collections.emptyList());

        Map<String, Object> result = emergencyService.cancelEmergency(emergencyId, userId, req);

        // La interfaz recibe apariencia de CANCELADA para engañar al agresor
        assertEquals("CANCELADA", result.get("estado"));
        assertEquals(true, result.get("coaccionDetectada"));

        // Pero la entidad en base de datos SIGUE ACTIVA con flag de posible coacción
        assertTrue(mockEmergency.getPosibleCoaccion());
        assertNotEquals("CANCELADA", mockEmergency.getEstado());
        verify(emergenciaRepository).save(mockEmergency);
    }

    @Test
    void testCancelWithWrongPinThrowsBadRequest() {
        CancelEmergencyRequest req = new CancelEmergencyRequest();
        req.setPin("0000"); // PIN incorrecto

        when(emergenciaRepository.findById(emergencyId)).thenReturn(Optional.of(mockEmergency));
        when(usuarioRepository.findById(userId)).thenReturn(Optional.of(mockUser));
        when(passwordEncoder.matches("0000", "hashed_coercion_pin")).thenReturn(false);
        when(passwordEncoder.matches("0000", "hashed_normal_pin")).thenReturn(false);

        assertThrows(BadRequestException.class, () -> emergencyService.cancelEmergency(emergencyId, userId, req));
    }
}
