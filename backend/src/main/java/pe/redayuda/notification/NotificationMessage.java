package pe.redayuda.notification;

import java.util.Map;
import java.util.UUID;

public class NotificationMessage {
    private UUID emergencyId;
    private UUID contactId;
    private String recipient;
    private NotificationChannel channel;
    private String title;
    private String message;
    private Map<String, String> data;

    public NotificationMessage() {}

    public NotificationMessage(UUID emergencyId, UUID contactId, String recipient, NotificationChannel channel, String title, String message, Map<String, String> data) {
        this.emergencyId = emergencyId;
        this.contactId = contactId;
        this.recipient = recipient;
        this.channel = channel;
        this.title = title;
        this.message = message;
        this.data = data;
    }

    public UUID getEmergencyId() { return emergencyId; }
    public void setEmergencyId(UUID emergencyId) { this.emergencyId = emergencyId; }

    public UUID getContactId() { return contactId; }
    public void setContactId(UUID contactId) { this.contactId = contactId; }

    public String getRecipient() { return recipient; }
    public void setRecipient(String recipient) { this.recipient = recipient; }

    public NotificationChannel getChannel() { return channel; }
    public void setChannel(NotificationChannel channel) { this.channel = channel; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public Map<String, String> getData() { return data; }
    public void setData(Map<String, String> data) { this.data = data; }
}
