package pe.redayuda.dto;

import java.util.Set;
import java.util.UUID;

public class UserSummaryDto {
    private UUID id;
    private String nombres;
    private String apellidos;
    private String email;
    private String telefono;
    private Set<String> roles;
    private String estadoVerificacion;
    private boolean tienePinConfigurado;

    public UserSummaryDto() {}

    public UserSummaryDto(UUID id, String nombres, String apellidos, String email, String telefono, Set<String> roles, String estadoVerificacion, boolean tienePinConfigurado) {
        this.id = id;
        this.nombres = nombres;
        this.apellidos = apellidos;
        this.email = email;
        this.telefono = telefono;
        this.roles = roles;
        this.estadoVerificacion = estadoVerificacion;
        this.tienePinConfigurado = tienePinConfigurado;
    }

    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public String getNombres() { return nombres; }
    public void setNombres(String nombres) { this.nombres = nombres; }

    public String getApellidos() { return apellidos; }
    public void setApellidos(String apellidos) { this.apellidos = apellidos; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getTelefono() { return telefono; }
    public void setTelefono(String telefono) { this.telefono = telefono; }

    public Set<String> getRoles() { return roles; }
    public void setRoles(Set<String> roles) { this.roles = roles; }

    public String getEstadoVerificacion() { return estadoVerificacion; }
    public void setEstadoVerificacion(String estadoVerificacion) { this.estadoVerificacion = estadoVerificacion; }

    public boolean isTienePinConfigurado() { return tienePinConfigurado; }
    public void setTienePinConfigurado(boolean tienePinConfigurado) { this.tienePinConfigurado = tienePinConfigurado; }
}
