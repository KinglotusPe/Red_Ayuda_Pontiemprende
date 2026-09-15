package pe.redayuda.dto;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.UUID;

public class EmergencyResponse {
    private UUID id;
    private UUID usuarioId;
    private String usuarioNombre;
    private String tipo;
    private String estado;
    private boolean posibleCoaccion;
    private Integer nivelBateria;
    private boolean dispositivoOffline;
    private OffsetDateTime fechaInicio;
    private OffsetDateTime fechaCierre;
    private LocationDto ultimaUbicacion;
    private List<EventDto> eventos;
    private String shareUrl;
    private String audioSignedUrl;

    public static class LocationDto {
        private Double latitud;
        private Double longitud;
        private Double precisionMetros;
        private String fuente;
        private String estadoMovimiento;
        private Double velocidadKmh;
        private OffsetDateTime timestamp;

        public LocationDto() {}

        public LocationDto(Double latitud, Double longitud, Double precisionMetros, String fuente, String estadoMovimiento, Double velocidadKmh, OffsetDateTime timestamp) {
            this.latitud = latitud;
            this.longitud = longitud;
            this.precisionMetros = precisionMetros;
            this.fuente = fuente;
            this.estadoMovimiento = estadoMovimiento;
            this.velocidadKmh = velocidadKmh;
            this.timestamp = timestamp;
        }

        public Double getLatitud() { return latitud; }
        public void setLatitud(Double latitud) { this.latitud = latitud; }

        public Double getLongitud() { return longitud; }
        public void setLongitud(Double longitud) { this.longitud = longitud; }

        public Double getPrecisionMetros() { return precisionMetros; }
        public void setPrecisionMetros(Double precisionMetros) { this.precisionMetros = precisionMetros; }

        public String getFuente() { return fuente; }
        public void setFuente(String fuente) { this.fuente = fuente; }

        public String getEstadoMovimiento() { return estadoMovimiento; }
        public void setEstadoMovimiento(String estadoMovimiento) { this.estadoMovimiento = estadoMovimiento; }

        public Double getVelocidadKmh() { return velocidadKmh; }
        public void setVelocidadKmh(Double velocidadKmh) { this.velocidadKmh = velocidadKmh; }

        public OffsetDateTime getTimestamp() { return timestamp; }
        public void setTimestamp(OffsetDateTime timestamp) { this.timestamp = timestamp; }
    }

    public static class EventDto {
        private String tipoEvento;
        private String metadataJson;
        private OffsetDateTime timestamp;

        public EventDto() {}

        public EventDto(String tipoEvento, String metadataJson, OffsetDateTime timestamp) {
            this.tipoEvento = tipoEvento;
            this.metadataJson = metadataJson;
            this.timestamp = timestamp;
        }

        public String getTipoEvento() { return tipoEvento; }
        public void setTipoEvento(String tipoEvento) { this.tipoEvento = tipoEvento; }

        public String getMetadataJson() { return metadataJson; }
        public void setMetadataJson(String metadataJson) { this.metadataJson = metadataJson; }

        public OffsetDateTime getTimestamp() { return timestamp; }
        public void setTimestamp(OffsetDateTime timestamp) { this.timestamp = timestamp; }
    }

    public EmergencyResponse() {}

    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public UUID getUsuarioId() { return usuarioId; }
    public void setUsuarioId(UUID usuarioId) { this.usuarioId = usuarioId; }

    public String getUsuarioNombre() { return usuarioNombre; }
    public void setUsuarioNombre(String usuarioNombre) { this.usuarioNombre = usuarioNombre; }

    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public boolean isPosibleCoaccion() { return posibleCoaccion; }
    public void setPosibleCoaccion(boolean posibleCoaccion) { this.posibleCoaccion = posibleCoaccion; }

    public Integer getNivelBateria() { return nivelBateria; }
    public void setNivelBateria(Integer nivelBateria) { this.nivelBateria = nivelBateria; }

    public boolean isDispositivoOffline() { return dispositivoOffline; }
    public void setDispositivoOffline(boolean dispositivoOffline) { this.dispositivoOffline = dispositivoOffline; }

    public OffsetDateTime getFechaInicio() { return fechaInicio; }
    public void setFechaInicio(OffsetDateTime fechaInicio) { this.fechaInicio = fechaInicio; }

    public OffsetDateTime getFechaCierre() { return fechaCierre; }
    public void setFechaCierre(OffsetDateTime fechaCierre) { this.fechaCierre = fechaCierre; }

    public LocationDto getUltimaUbicacion() { return ultimaUbicacion; }
    public void setUltimaUbicacion(LocationDto ultimaUbicacion) { this.ultimaUbicacion = ultimaUbicacion; }

    public List<EventDto> getEventos() { return eventos; }
    public void setEventos(List<EventDto> eventos) { this.eventos = eventos; }

    public String getShareUrl() { return shareUrl; }
    public void setShareUrl(String shareUrl) { this.shareUrl = shareUrl; }

    public String getAudioSignedUrl() { return audioSignedUrl; }
    public void setAudioSignedUrl(String audioSignedUrl) { this.audioSignedUrl = audioSignedUrl; }
}
