package pe.redayuda.entity;

import jakarta.persistence.*;
import java.time.OffsetDateTime;
import java.util.UUID;

@Entity
@Table(name = "directorio_emergencia")
public class DirectorioEmergencia {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(nullable = false, length = 100)
    private String nombre;

    @Column(nullable = false, length = 30)
    private String tipo; // POLICIA, SAMU, BOMBEROS, SERENAZGO, HOSPITAL, DEFENSA_CIVIL

    @Column(nullable = false, length = 20)
    private String telefono;

    @Column(nullable = false, length = 50)
    private String region = "Ayacucho";

    @Column(nullable = false, length = 50)
    private String provincia = "Huamanga";

    @Column(nullable = false, length = 50)
    private String distrito = "Ayacucho";

    @Column(nullable = false)
    private Integer prioridad = 1;

    @Column(nullable = false)
    private Boolean activo = true;

    @Column(name = "fuente_verificacion", length = 100)
    private String fuenteVerificacion;

    @Column(name = "fecha_verificacion")
    private OffsetDateTime fechaVerificacion = OffsetDateTime.now();

    public DirectorioEmergencia() {}

    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }

    public String getTelefono() { return telefono; }
    public void setTelefono(String telefono) { this.telefono = telefono; }

    public String getRegion() { return region; }
    public void setRegion(String region) { this.region = region; }

    public String getProvincia() { return provincia; }
    public void setProvincia(String provincia) { this.provincia = provincia; }

    public String getDistrito() { return distrito; }
    public void setDistrito(String distrito) { this.distrito = distrito; }

    public Integer getPrioridad() { return prioridad; }
    public void setPrioridad(Integer prioridad) { this.prioridad = prioridad; }

    public Boolean getActivo() { return activo; }
    public void setActivo(Boolean activo) { this.activo = activo; }

    public String getFuenteVerificacion() { return fuenteVerificacion; }
    public void setFuenteVerificacion(String fuenteVerificacion) { this.fuenteVerificacion = fuenteVerificacion; }

    public OffsetDateTime getFechaVerificacion() { return fechaVerificacion; }
    public void setFechaVerificacion(OffsetDateTime fechaVerificacion) { this.fechaVerificacion = fechaVerificacion; }
}
