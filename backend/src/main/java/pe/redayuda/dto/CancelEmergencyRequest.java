package pe.redayuda.dto;

import jakarta.validation.constraints.NotBlank;

public class CancelEmergencyRequest {

    @NotBlank(message = "El PIN de confirmación es obligatorio")
    private String pin;

    private String motivo;

    public CancelEmergencyRequest() {}

    public String getPin() { return pin; }
    public void setPin(String pin) { this.pin = pin; }

    public String getMotivo() { return motivo; }
    public void setMotivo(String motivo) { this.motivo = motivo; }
}
