package pe.redayuda.dto;

import jakarta.validation.constraints.NotNull;

public class LocationUpdateRequest {

    @NotNull(message = "La latitud es obligatoria")
    private Double latitud;

    @NotNull(message = "La longitud es obligatoria")
    private Double longitud;

    private Double precisionMetros;
    private String fuente = "GPS";
    private Double velocidadKmh;
    private Integer nivelBateria;

    public LocationUpdateRequest() {}

    public Double getLatitud() { return latitud; }
    public void setLatitud(Double latitud) { this.latitud = latitud; }

    public Double getLongitud() { return longitud; }
    public void setLongitud(Double longitud) { this.longitud = longitud; }

    public Double getPrecisionMetros() { return precisionMetros; }
    public void setPrecisionMetros(Double precisionMetros) { this.precisionMetros = precisionMetros; }

    public String getFuente() { return fuente; }
    public void setFuente(String fuente) { this.fuente = fuente; }

    public Double getVelocidadKmh() { return velocidadKmh; }
    public void setVelocidadKmh(Double velocidadKmh) { this.velocidadKmh = velocidadKmh; }

    public Integer getNivelBateria() { return nivelBateria; }
    public void setNivelBateria(Integer nivelBateria) { this.nivelBateria = nivelBateria; }
}
