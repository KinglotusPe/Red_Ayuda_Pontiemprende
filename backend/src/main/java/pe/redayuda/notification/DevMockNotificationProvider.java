package pe.redayuda.notification;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

@Component
public class DevMockNotificationProvider implements NotificationProvider {

    private static final Logger logger = LoggerFactory.getLogger(DevMockNotificationProvider.class);

    @Override
    public boolean supports(NotificationChannel channel) {
        return true; // Soporta simulación para todos los canales en entorno DEV/fallback
    }

    @Override
    public String getProviderName() {
        return "DEV_MOCK_PROVIDER";
    }

    @Override
    public NotificationResult send(NotificationMessage message) {
        logger.info("""
                ============================================================
                [ALERTA DE SEGURIDAD - SIMULADO DEV: NO ENVIADO REALMENTE]
                Canal: {}
                Destinatario: {}
                Título: {}
                Mensaje: {}
                Emergencia ID: {}
                Proveedor: {}
                ============================================================""",
                message.getChannel(),
                message.getRecipient(),
                message.getTitle(),
                message.getMessage(),
                message.getEmergencyId(),
                getProviderName());

        return new NotificationResult(
                true,
                "SIMULADO_DEV",
                getProviderName(),
                null
        );
    }
}
