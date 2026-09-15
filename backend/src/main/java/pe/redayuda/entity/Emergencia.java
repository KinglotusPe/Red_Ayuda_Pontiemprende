package pe.redayuda.entity;

import jakarta.persistence.*;
import java.time.OffsetDateTime;
import java.util.UUID;

@Entity
@Table(name = "emergencias")
public class Emergencia {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario;

    @Column(nullable = false, length = 30)
    private String tipo; // ROBO, AGRESION, ACOSO, ACCIDENTE, EMERGENCIA_MEDICA, etc.

    @Column(nullable = false, length = 30)
    private String estado = "CREADA"; // CREADA, ACTIVA, AYUDA_SOLICITADA, EN_ATENCION, RESUELTA, CANCELADA, FALSA_ALARMA

    @Column(name = "posible_coaccion", nullable = false)
    private Boolean posibleCoaccion = false;

    @Column(name = "nivel_bateria")
    private Integer nivelBateria;

    @Column(name = "dispositivo_offline", nullable = false)
    private Boolean dispositivoOffline = false;

    @Column(name = "motivo_cancelacion")
    private String motivoCancelacion;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cancelado_por_usuario_id")
    private Usuario canceladoPor;

    @Column(name = "fecha_inicio", updatable = false)
    private OffsetDateTime fechaInicio = OffsetDateTime.now();

    @Column(name = "fecha_cierre")
    private OffsetDateTime fechaCierre;

    public Emergencia() {}

    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public Usuario getUsuario() { return usuario; }
    public void setUsuario(Usuario usuario) { this.usuario = usuario; }

    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public Boolean getPosibleCoaccion() { return posibleCoaccion; }
    public void setPosibleCoaccion(Boolean posibleCoaccion) { this.posibleCoaccion = posibleCoaccion; }

    public Integer getNivelBateria() { return nivelBateria; }
    public void setNivelBateria(Integer nivelBateria) { this.nivelBateria = nivelBateria; }

    public Boolean getDispositivoOffline() { return dispositivoOffline; }
    public void setDispositivoOffline(Boolean dispositivoOffline) { this.dispositivoOffline = dispositivoOffline; }

    public String getMotivoCancelacion() { return motivoCancelacion; }
    public void setMotivoCancelacion(String motivoCancelacion) { this.motivoCancelacion = motivoCancelacion; }

    public Usuario getCanceladoPor() { return canceladoPor; }
    public void setCanceladoPor(Usuario canceladoPor) { this.canceladoPor = canceladoPor; }

    public OffsetDateTime getFechaInicio() { return fechaInicio; }
    public void setFechaInicio(OffsetDateTime fechaInicio) { this.fechaInicio = fechaInicio; }

    public OffsetDateTime getFechaCierre() { return fechaCierre; }
    public void setFechaCierre(OffsetDateTime fechaCierre) { this.fechaCierre = fechaCierre; }
}
