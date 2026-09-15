package pe.redayuda.entity;

import jakarta.persistence.*;
import java.time.OffsetDateTime;
import java.util.UUID;

@Entity
@Table(name = "emergencia_audios")
public class EmergenciaAudio {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "emergencia_id", nullable = false)
    private Emergencia emergencia;

    @Column(name = "storage_key", nullable = false)
    private String storageKey;

    @Column(name = "duracion_segundos", nullable = false)
    private Integer duracionSegundos;

    @Column(name = "tamano_bytes", nullable = false)
    private Long tamanoBytes;

    @Column(length = 20)
    private String formato = "audio/aac";

    @Column(name = "estado_subida", length = 30)
    private String estadoSubida = "SUBIDO";

    @Column(name = "fecha_grabacion", updatable = false)
    private OffsetDateTime fechaGrabacion = OffsetDateTime.now();

    public EmergenciaAudio() {}

    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public Emergencia getEmergencia() { return emergencia; }
    public void setEmergencia(Emergencia emergencia) { this.emergencia = emergencia; }

    public String getStorageKey() { return storageKey; }
    public void setStorageKey(String storageKey) { this.storageKey = storageKey; }

    public Integer getDuracionSegundos() { return duracionSegundos; }
    public void setDuracionSegundos(Integer duracionSegundos) { this.duracionSegundos = duracionSegundos; }

    public Long getTamanoBytes() { return tamanoBytes; }
    public void setTamanoBytes(Long tamanoBytes) { this.tamanoBytes = tamanoBytes; }

    public String getFormato() { return formato; }
    public void setFormato(String formato) { this.formato = formato; }

    public String getEstadoSubida() { return estadoSubida; }
    public void setEstadoSubida(String estadoSubida) { this.estadoSubida = estadoSubida; }

    public OffsetDateTime getFechaGrabacion() { return fechaGrabacion; }
    public void setFechaGrabacion(OffsetDateTime fechaGrabacion) { this.fechaGrabacion = fechaGrabacion; }
}
