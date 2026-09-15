package pe.redayuda.entity;

import jakarta.persistence.*;
import java.time.OffsetDateTime;
import java.util.UUID;

@Entity
@Table(name = "auditoria_accesos")
public class AuditoriaAcceso {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "usuario_id")
    private UUID usuarioId;

    @Column(nullable = false, length = 100)
    private String accion;

    @Column(length = 100)
    private String recurso;

    @Column(name = "ip_origen", length = 45)
    private String ipOrigen;

    @Column(name = "user_agent", length = 255)
    private String userAgent;

    @Column(name = "timestamp", updatable = false)
    private OffsetDateTime timestamp = OffsetDateTime.now();

    public AuditoriaAcceso() {}

    public AuditoriaAcceso(UUID usuarioId, String accion, String recurso, String ipOrigen, String userAgent) {
        this.usuarioId = usuarioId;
        this.accion = accion;
        this.recurso = recurso;
        this.ipOrigen = ipOrigen;
        this.userAgent = userAgent;
    }

    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public UUID getUsuarioId() { return usuarioId; }
    public void setUsuarioId(UUID usuarioId) { this.usuarioId = usuarioId; }

    public String getAccion() { return accion; }
    public void setAccion(String accion) { this.accion = accion; }

    public String getRecurso() { return recurso; }
    public void setRecurso(String recurso) { this.recurso = recurso; }

    public String getIpOrigen() { return ipOrigen; }
    public void setIpOrigen(String ipOrigen) { this.ipOrigen = ipOrigen; }

    public String getUserAgent() { return userAgent; }
    public void setUserAgent(String userAgent) { this.userAgent = userAgent; }

    public OffsetDateTime getTimestamp() { return timestamp; }
    public void setTimestamp(OffsetDateTime timestamp) { this.timestamp = timestamp; }
}
