package pe.redayuda.dto;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.UUID;

public class PublicEmergencyShareDto {
    private UUID emergenciaId;
    private String nombreVictima;
    private String tipo;
    private String estado;
    private OffsetDateTime fechaInicio;
    private Double latitud;
    private Double longitud;
    private Double precisionMetros;
    private String fuente;
    private OffsetDateTime ultimaActualizacion;
    private Integer nivelBateria;
    private boolean dispositivoOffline;
    private boolean audioDisponible;
    private String audioSignedUrl;
    private List<DirectoryItemDto> serviciosEmergencia;

    public PublicEmergencyShareDto() {}

    public UUID getEmergenciaId() { return emergenciaId; }
    public void setEmergenciaId(UUID emergenciaId) { this.emergenciaId = emergenciaId; }

    public String getNombreVictima() { return nombreVictima; }
    public void setNombreVictima(String nombreVictima) { this.nombreVictima = nombreVictima; }

    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public OffsetDateTime getFechaInicio() { return fechaInicio; }
    public void setFechaInicio(OffsetDateTime fechaInicio) { this.fechaInicio = fechaInicio; }

    public Double getLatitud() { return latitud; }
    public void setLatitud(Double latitud) { this.latitud = latitud; }

    public Double getLongitud() { return longitud; }
    public void setLongitud(Double longitud) { this.longitud = longitud; }

    public Double getPrecisionMetros() { return precisionMetros; }
    public void setPrecisionMetros(Double precisionMetros) { this.precisionMetros = precisionMetros; }

    public String getFuente() { return fuente; }
    public void setFuente(String fuente) { this.fuente = fuente; }

    public OffsetDateTime getUltimaActualizacion() { return ultimaActualizacion; }
    public void setUltimaActualizacion(OffsetDateTime ultimaActualizacion) { this.ultimaActualizacion = ultimaActualizacion; }

    public Integer getNivelBateria() { return nivelBateria; }
    public void setNivelBateria(Integer nivelBateria) { this.nivelBateria = nivelBateria; }

    public boolean isDispositivoOffline() { return dispositivoOffline; }
    public void setDispositivoOffline(boolean dispositivoOffline) { this.dispositivoOffline = dispositivoOffline; }

    public boolean isAudioDisponible() { return audioDisponible; }
    public void setAudioDisponible(boolean audioDisponible) { this.audioDisponible = audioDisponible; }

    public String getAudioSignedUrl() { return audioSignedUrl; }
    public void setAudioSignedUrl(String audioSignedUrl) { this.audioSignedUrl = audioSignedUrl; }

    public List<DirectoryItemDto> getServiciosEmergencia() { return serviciosEmergencia; }
    public void setServiciosEmergencia(List<DirectoryItemDto> serviciosEmergencia) { this.serviciosEmergencia = serviciosEmergencia; }
}
