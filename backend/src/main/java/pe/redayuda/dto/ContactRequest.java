package pe.redayuda.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;

public class ContactRequest {

    @NotBlank(message = "El nombre es obligatorio")
    private String nombre;

    @NotBlank(message = "El teléfono es obligatorio")
    @Pattern(regexp = "^\\+?[0-9]{9,15}$", message = "Formato de teléfono inválido")
    private String telefono;

    private String email;
    private String parentesco;
    private Integer prioridad = 1;
    private Boolean permiteUbicacionPrecisa = true;
    private Boolean permiteAudio = true;

    public ContactRequest() {}

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

    public Boolean getPermiteUbicacionPrecisa() { return permiteUbicacionPrecisa; }
    public void setPermiteUbicacionPrecisa(Boolean permiteUbicacionPrecisa) { this.permiteUbicacionPrecisa = permiteUbicacionPrecisa; }

    public Boolean getPermiteAudio() { return permiteAudio; }
    public void setPermiteAudio(Boolean permiteAudio) { this.permiteAudio = permiteAudio; }
}
