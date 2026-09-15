package pe.redayuda.dto;

import jakarta.validation.constraints.NotBlank;

public class TriggerSosRequest {

    @NotBlank(message = "El tipo de emergencia es obligatorio")
    private String tipo = "DESCONOCIDA"; // ROBO, AGRESION, ACOSO, ACCIDENTE, etc.

    private Double latitud;
    private Double longitud;
    private Double precisionMetros;
    private String fuente = "GPS"; // GPS, NETWORK, LAST_KNOWN, UNKNOWN
    private Integer nivelBateria;

    public TriggerSosRequest() {}

    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }

    public Double getLatitud() { return latitud; }
    public void setLatitud(Double latitud) { this.latitud = latitud; }

    public Double getLongitud() { return longitud; }
    public void setLongitud(Double longitud) { this.longitud = longitud; }

    public Double getPrecisionMetros() { return precisionMetros; }
    public void setPrecisionMetros(Double precisionMetros) { this.precisionMetros = precisionMetros; }

    public String getFuente() { return fuente; }
    public void setFuente(String fuente) { this.fuente = fuente; }

    public Integer getNivelBateria() { return nivelBateria; }
    public void setNivelBateria(Integer nivelBateria) { this.nivelBateria = nivelBateria; }
}
