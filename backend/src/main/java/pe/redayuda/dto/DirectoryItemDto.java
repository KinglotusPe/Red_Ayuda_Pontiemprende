package pe.redayuda.dto;

import java.util.UUID;

public class DirectoryItemDto {
    private UUID id;
    private String nombre;
    private String tipo;
    private String telefono;
    private String region;
    private String provincia;
    private String distrito;
    private Integer prioridad;

    public DirectoryItemDto() {}

    public DirectoryItemDto(UUID id, String nombre, String tipo, String telefono, String region, String provincia, String distrito, Integer prioridad) {
        this.id = id;
        this.nombre = nombre;
        this.tipo = tipo;
        this.telefono = telefono;
        this.region = region;
        this.provincia = provincia;
        this.distrito = distrito;
        this.prioridad = prioridad;
    }

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
}
