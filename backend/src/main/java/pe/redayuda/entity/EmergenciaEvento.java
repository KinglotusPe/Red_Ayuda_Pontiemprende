package pe.redayuda.entity;

import jakarta.persistence.*;
import java.time.OffsetDateTime;
import java.util.UUID;

@Entity
@Table(name = "emergencia_eventos")
public class EmergenciaEvento {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "emergencia_id", nullable = false)
    private Emergencia emergencia;

    @Column(name = "tipo_evento", nullable = false, length = 50)
    private String tipoEvento;

    @Column(name = "metadata_json", columnDefinition = "TEXT")
    private String metadataJson;

    @Column(name = "timestamp", updatable = false)
    private OffsetDateTime timestamp = OffsetDateTime.now();

    public EmergenciaEvento() {}

    public EmergenciaEvento(Emergencia emergencia, String tipoEvento, String metadataJson) {
        this.emergencia = emergencia;
        this.tipoEvento = tipoEvento;
        this.metadataJson = metadataJson;
    }

    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public Emergencia getEmergencia() { return emergencia; }
    public void setEmergencia(Emergencia emergencia) { this.emergencia = emergencia; }

    public String getTipoEvento() { return tipoEvento; }
    public void setTipoEvento(String tipoEvento) { this.tipoEvento = tipoEvento; }

    public String getMetadataJson() { return metadataJson; }
    public void setMetadataJson(String metadataJson) { this.metadataJson = metadataJson; }

    public OffsetDateTime getTimestamp() { return timestamp; }
    public void setTimestamp(OffsetDateTime timestamp) { this.timestamp = timestamp; }
}
