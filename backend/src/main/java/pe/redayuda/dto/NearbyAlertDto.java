package pe.redayuda.dto;

import java.time.OffsetDateTime;
import java.util.UUID;

public class NearbyAlertDto {
    private UUID id;
    private String tipo;
    private Double distanciaAproximadaMetros;
    private String zonaAproximada;
    private OffsetDateTime timestamp;
    private String estado;

    public NearbyAlertDto() {}

    public NearbyAlertDto(UUID id, String tipo, Double distanciaAproximadaMetros, String zonaAproximada, OffsetDateTime timestamp, String estado) {
        this.id = id;
        this.tipo = tipo;
        this.distanciaAproximadaMetros = distanciaAproximadaMetros;
        this.zonaAproximada = zonaAproximada;
        this.timestamp = timestamp;
        this.estado = estado;
    }

    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }

    public Double getDistanciaAproximadaMetros() { return distanciaAproximadaMetros; }
    public void setDistanciaAproximadaMetros(Double distanciaAproximadaMetros) { this.distanciaAproximadaMetros = distanciaAproximadaMetros; }

    public String getZonaAproximada() { return zonaAproximada; }
    public void setZonaAproximada(String zonaAproximada) { this.zonaAproximada = zonaAproximada; }

    public OffsetDateTime getTimestamp() { return timestamp; }
    public void setTimestamp(OffsetDateTime timestamp) { this.timestamp = timestamp; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
}
