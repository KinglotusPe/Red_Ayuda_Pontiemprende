package pe.redayuda.dto;

import java.util.Map;

public class AdminStatsDto {
    private long totalUsuarios;
    private long usuariosVerificados;
    private long emergenciasActivas;
    private long emergenciasHoy;
    private long emergenciasMes;
    private long falsasAlarmas;
    private long notificacionesFallidas;
    private Map<String, Long> emergenciasPorTipo;

    public AdminStatsDto() {}

    public long getTotalUsuarios() { return totalUsuarios; }
    public void setTotalUsuarios(long totalUsuarios) { this.totalUsuarios = totalUsuarios; }

    public long getUsuariosVerificados() { return usuariosVerificados; }
    public void setUsuariosVerificados(long usuariosVerificados) { this.usuariosVerificados = usuariosVerificados; }

    public long getEmergenciasActivas() { return emergenciasActivas; }
    public void setEmergenciasActivas(long emergenciasActivas) { this.emergenciasActivas = emergenciasActivas; }

    public long getEmergenciasHoy() { return emergenciasHoy; }
    public void setEmergenciasHoy(long emergenciasHoy) { this.emergenciasHoy = emergenciasHoy; }

    public long getEmergenciasMes() { return emergenciasMes; }
    public void setEmergenciasMes(long emergenciasMes) { this.emergenciasMes = emergenciasMes; }

    public long getFalsasAlarmas() { return falsasAlarmas; }
    public void setFalsasAlarmas(long falsasAlarmas) { this.falsasAlarmas = falsasAlarmas; }

    public long getNotificacionesFallidas() { return notificacionesFallidas; }
    public void setNotificacionesFallidas(long notificacionesFallidas) { this.notificacionesFallidas = notificacionesFallidas; }

    public Map<String, Long> getEmergenciasPorTipo() { return emergenciasPorTipo; }
    public void setEmergenciasPorTipo(Map<String, Long> emergenciasPorTipo) { this.emergenciasPorTipo = emergenciasPorTipo; }
}
