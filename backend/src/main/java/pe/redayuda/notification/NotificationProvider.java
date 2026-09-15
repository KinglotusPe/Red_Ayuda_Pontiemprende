package pe.redayuda.notification;

public interface NotificationProvider {

    boolean supports(NotificationChannel channel);

    String getProviderName();

    /**
     * @return true si fue enviado exitosamente o simulado válidamente en DEV.
     */
    NotificationResult send(NotificationMessage message);

    record NotificationResult(boolean success, String status, String provider, String errorMessage) {}
}
