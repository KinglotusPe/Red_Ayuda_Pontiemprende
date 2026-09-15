package pe.redayuda.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;

public class SetupPinRequest {

    @NotBlank(message = "El PIN normal es obligatorio")
    @Pattern(regexp = "^[0-9]{4,6}$", message = "El PIN normal debe tener entre 4 y 6 dígitos")
    private String pin;

    @NotBlank(message = "El PIN de coacción es obligatorio")
    @Pattern(regexp = "^[0-9]{4,6}$", message = "El PIN de coacción debe tener entre 4 y 6 dígitos")
    private String pinCoercion;

    public SetupPinRequest() {}

    public String getPin() { return pin; }
    public void setPin(String pin) { this.pin = pin; }

    public String getPinCoercion() { return pinCoercion; }
    public void setPinCoercion(String pinCoercion) { this.pinCoercion = pinCoercion; }
}
