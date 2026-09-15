package pe.redayuda.entity;

import jakarta.persistence.*;
import java.time.OffsetDateTime;
import java.util.UUID;

@Entity
@Table(name = "emergencia_notificaciones")
public class EmergenciaNotificacion {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "emergencia_id", nullable = false)
    private Emergencia emergencia;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "contacto_id")
    private ContactoConfianza contacto;

    @Column(nullable = false, length = 20)
    private String canal; // PUSH, SMS, WHATSAPP, EMAIL

    @Column(nullable = false, length = 150)
    private String destinatario;

    @Column(nullable = false, length = 50)
    private String proveedor;

    @Column(nullable = false, length = 30)
    private String estado; // ENVIADO, FALLIDO, SIMULADO_DEV

    @Column(nullable = false)
    private Integer intentos = 1;

    @Column(columnDefinition = "TEXT")
    private String error;

    @Column(name = "timestamp", updatable = false)
    private OffsetDateTime timestamp = OffsetDateTime.now();

    public EmergenciaNotificacion() {}

    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public Emergencia getEmergencia() { return emergencia; }
    public void setEmergencia(Emergencia emergencia) { this.emergencia = emergencia; }

    public ContactoConfianza getContacto() { return contacto; }
    public void setContacto(ContactoConfianza contacto) { this.contacto = contacto; }

    public String getCanal() { return canal; }
    public void setCanal(String canal) { this.canal = canal; }

    public String getDestinatario() { return destinatario; }
    public void setDestinatario(String destinatario) { this.destinatario = destinatario; }

    public String getProveedor() { return proveedor; }
    public void setProveedor(String proveedor) { this.proveedor = proveedor; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public Integer getIntentos() { return intentos; }
    public void setIntentos(Integer intentos) { this.intentos = intentos; }

    public String getError() { return error; }
    public void setError(String error) { this.error = error; }

    public OffsetDateTime getTimestamp() { return timestamp; }
    public void setTimestamp(OffsetDateTime timestamp) { this.timestamp = timestamp; }
}
