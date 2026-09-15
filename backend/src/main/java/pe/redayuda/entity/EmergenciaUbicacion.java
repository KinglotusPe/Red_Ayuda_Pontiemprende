package pe.redayuda.entity;

import jakarta.persistence.*;
import java.time.OffsetDateTime;
import java.util.UUID;

@Entity
@Table(name = "emergencia_ubicaciones")
public class EmergenciaUbicacion {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "emergencia_id", nullable = false)
    private Emergencia emergencia;

    @Column(nullable = false)
    private Double latitud;

    @Column(nullable = false)
    private Double longitud;

    @Column(name = "precision_metros")
    private Double precisionMetros;

    @Column(nullable = false, length = 30)
    private String fuente; // GPS, PRECISE_SYSTEM, NETWORK, APPROXIMATE, LAST_KNOWN, UNKNOWN

    @Column(name = "estado_movimiento", length = 30)
    private String estadoMovimiento = "QUIETO"; // QUIETO, DESPLAZAMIENTO, MOVIMIENTO_RAPIDO

    @Column(name = "velocidad_kmh")
    private Double velocidadKmh;

    @Column(name = "es_inicial")
    private Boolean esInicial = false;

    @Column(name = "es_ultima_conocida")
    private Boolean esUltimaConocida = false;

    @Column(name = "timestamp", updatable = false)
    private OffsetDateTime timestamp = OffsetDateTime.now();

    public EmergenciaUbicacion() {}

    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public Emergencia getEmergencia() { return emergencia; }
    public void setEmergencia(Emergencia emergencia) { this.emergencia = emergencia; }

    public Double getLatitud() { return latitud; }
    public void setLatitud(Double latitud) { this.latitud = latitud; }

    public Double getLongitud() { return longitud; }
    public void setLongitud(Double longitud) { this.longitud = longitud; }

    public Double getPrecisionMetros() { return precisionMetros; }
    public void setPrecisionMetros(Double precisionMetros) { this.precisionMetros = precisionMetros; }

    public String getFuente() { return fuente; }
    public void setFuente(String fuente) { this.fuente = fuente; }

    public String getEstadoMovimiento() { return estadoMovimiento; }
    public void setEstadoMovimiento(String estadoMovimiento) { this.estadoMovimiento = estadoMovimiento; }

    public Double getVelocidadKmh() { return velocidadKmh; }
    public void setVelocidadKmh(Double velocidadKmh) { this.velocidadKmh = velocidadKmh; }

    public Boolean getEsInicial() { return esInicial; }
    public void setEsInicial(Boolean esInicial) { this.esInicial = esInicial; }

    public Boolean getEsUltimaConocida() { return esUltimaConocida; }
    public void setEsUltimaConocida(Boolean esUltimaConocida) { this.esUltimaConocida = esUltimaConocida; }

    public OffsetDateTime getTimestamp() { return timestamp; }
    public void setTimestamp(OffsetDateTime timestamp) { this.timestamp = timestamp; }
}
