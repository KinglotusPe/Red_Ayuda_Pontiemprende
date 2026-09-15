package pe.redayuda.dto;

import java.util.UUID;

public class ContactResponse {
    private UUID id;
    private String nombre;
    private String telefono;
    private String email;
    private String parentesco;
    private Integer prioridad;
    private Boolean tieneRedAyuda;
    private Boolean permiteUbicacionPrecisa;
    private Boolean permiteAudio;
    private Boolean activo;

    public ContactResponse() {}

    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

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

    public Boolean getPermiteUbicacionPrecisa() { return permiteUbicacionPrecisa; }
    public void setPermiteUbicacionPrecisa(Boolean permiteUbicacionPrecisa) { this.permiteUbicacionPrecisa = permiteUbicacionPrecisa; }

    public Boolean getPermiteAudio() { return permiteAudio; }
    public void setPermiteAudio(Boolean permiteAudio) { this.permiteAudio = permiteAudio; }

    public Boolean getActivo() { return activo; }
    public void setActivo(Boolean activo) { this.activo = activo; }
}
