package pe.redayuda.websocket;

import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import java.util.Map;
import java.util.UUID;

@Service
public class EmergencyWebSocketService {

    private final SimpMessagingTemplate messagingTemplate;

    public EmergencyWebSocketService(SimpMessagingTemplate messagingTemplate) {
        this.messagingTemplate = messagingTemplate;
    }

    /**
     * Publica actualización de emergencia (ubicación, estado, evento) a los suscriptores.
     */
    public void broadcastEmergencyUpdate(UUID emergencyId, Object payload) {
        messagingTemplate.convertAndSend("/topic/emergency/" + emergencyId, payload);
    }

    /**
     * Publica evento hacia el panel administrativo.
     */
    public void broadcastAdminAlert(Object payload) {
        messagingTemplate.convertAndSend("/topic/admin/emergencies", payload);
    }

    /**
     * Publica alerta de radar anónima a vecindarios en el radio.
     */
    public void broadcastRadarAlert(String zone, Object payload) {
        messagingTemplate.convertAndSend("/topic/radar/" + zone, payload);
    }
}
