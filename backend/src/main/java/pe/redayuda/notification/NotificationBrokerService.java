package pe.redayuda.notification;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.redayuda.entity.ContactoConfianza;
import pe.redayuda.entity.Emergencia;
import pe.redayuda.entity.EmergenciaNotificacion;
import pe.redayuda.repository.ContactoConfianzaRepository;
import pe.redayuda.repository.EmergenciaNotificacionRepository;
import pe.redayuda.repository.EmergenciaRepository;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.UUID;

@Service
public class NotificationBrokerService {

    private static final Logger logger = LoggerFactory.getLogger(NotificationBrokerService.class);

    private final List<NotificationProvider> providers;
    private final EmergenciaNotificacionRepository notificacionRepository;
    private final EmergenciaRepository emergenciaRepository;
    private final ContactoConfianzaRepository contactoRepository;

    public NotificationBrokerService(
            List<NotificationProvider> providers,
            EmergenciaNotificacionRepository notificacionRepository,
            EmergenciaRepository emergenciaRepository,
            ContactoConfianzaRepository contactoRepository) {
        this.providers = providers;
        this.notificacionRepository = notificacionRepository;
        this.emergenciaRepository = emergenciaRepository;
        this.contactoRepository = contactoRepository;
    }

    @Async
    @Transactional
    public void dispatchEmergencyAlert(NotificationMessage message) {
        NotificationProvider chosenProvider = providers.stream()
                .filter(p -> p.supports(message.getChannel()))
                .findFirst()
                .orElseGet(() -> providers.stream()
                        .filter(p -> p instanceof DevMockNotificationProvider)
                        .findFirst()
                        .orElseThrow());

        NotificationProvider.NotificationResult result = chosenProvider.send(message);

        // Persistir en base de datos para auditoría
        Emergencia emergencia = emergenciaRepository.findById(message.getEmergencyId()).orElse(null);
        if (emergencia == null) return;

        ContactoConfianza contacto = null;
        if (message.getContactId() != null) {
            contacto = contactoRepository.findById(message.getContactId()).orElse(null);
        }

        EmergenciaNotificacion notificacion = new EmergenciaNotificacion();
        notificacion.setEmergencia(emergencia);
        notificacion.setContacto(contacto);
        notificacion.setCanal(message.getChannel().name());
        notificacion.setDestinatario(message.getRecipient());
        notificacion.setProveedor(result.provider());
        notificacion.setEstado(result.status());
        notificacion.setError(result.errorMessage());
        notificacion.setIntentos(1);
        notificacion.setTimestamp(OffsetDateTime.now());

        notificacionRepository.save(notificacion);
        logger.info("Notificación guardada en BD. Canal: {}, Estado: {}", message.getChannel(), result.status());
    }
}
