package pe.redayuda.dto;

import jakarta.validation.constraints.NotBlank;

public class VerifyPinRequest {

    @NotBlank(message = "El PIN es obligatorio")
    private String pin;

    public VerifyPinRequest() {}

    public String getPin() { return pin; }
    public void setPin(String pin) { this.pin = pin; }
}
