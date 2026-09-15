package pe.redayuda.entity;

import jakarta.persistence.*;
import java.time.OffsetDateTime;
import java.util.UUID;

@Entity
@Table(name = "contactos_confianza")
public class ContactoConfianza {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario;

    @Column(nullable = false, length = 100)
    private String nombre;

    @Column(nullable = false, length = 20)
    private String telefono;

    @Column(length = 150)
    private String email;

    @Column(length = 50)
    private String parentesco;

    @Column(nullable = false)
    private Integer prioridad = 1;

    @Column(name = "tiene_red_ayuda")
    private Boolean tieneRedAyuda = false;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "usuario_red_ayuda_id")
    private Usuario usuarioRedAyuda;

    @Column(name = "permite_ubicacion_precisa")
    private Boolean permiteUbicacionPrecisa = true;

    @Column(name = "permite_audio")
    private Boolean permiteAudio = true;

    @Column(nullable = false)
    private Boolean activo = true;

    @Column(name = "fecha_creacion", updatable = false)
    private OffsetDateTime fechaCreacion = OffsetDateTime.now();

    public ContactoConfianza() {}

    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public Usuario getUsuario() { return usuario; }
    public void setUsuario(Usuario usuario) { this.usuario = usuario; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getTelefono() { return telefono; }
    public void setTelefono(String telefono) { this.telefono = telefono; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getParentesco() { return parentesco; }
    public void setParentesco(String parentesco) { this.parentesco = parentesco; }

    public Integer getPrioridad() { return prioridad; }
    public void setPrioridad(Integer prioridad) { this.prioridad = prioridad; }

    public Boolean getTieneRedAyuda() { return tieneRedAyuda; }
    public void setTieneRedAyuda(Boolean tieneRedAyuda) { this.tieneRedAyuda = tieneRedAyuda; }

    public Usuario getUsuarioRedAyuda() { return usuarioRedAyuda; }
    public void setUsuarioRedAyuda(Usuario usuarioRedAyuda) { this.usuarioRedAyuda = usuarioRedAyuda; }

    public Boolean getPermiteUbicacionPrecisa() { return permiteUbicacionPrecisa; }
    public void setPermiteUbicacionPrecisa(Boolean permiteUbicacionPrecisa) { this.permiteUbicacionPrecisa = permiteUbicacionPrecisa; }

    public Boolean getPermiteAudio() { return permiteAudio; }
    public void setPermiteAudio(Boolean permiteAudio) { this.permiteAudio = permiteAudio; }

    public Boolean getActivo() { return activo; }
    public void setActivo(Boolean activo) { this.activo = activo; }

    public OffsetDateTime getFechaCreacion() { return fechaCreacion; }
    public void setFechaCreacion(OffsetDateTime fechaCreacion) { this.fechaCreacion = fechaCreacion; }
}
