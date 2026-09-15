package pe.redayuda.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.redayuda.dto.AdminStatsDto;
import pe.redayuda.entity.AuditoriaAcceso;
import pe.redayuda.entity.Emergencia;
import pe.redayuda.repository.*;

import java.time.OffsetDateTime;
import java.time.temporal.ChronoUnit;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class AdminService {

    private final UsuarioRepository usuarioRepository;
    private final EmergenciaRepository emergenciaRepository;
    private final EmergenciaNotificacionRepository notificacionRepository;
    private final AuditoriaAccesoRepository auditoriaRepository;

    public AdminService(
            UsuarioRepository usuarioRepository,
            EmergenciaRepository emergenciaRepository,
            EmergenciaNotificacionRepository notificacionRepository,
            AuditoriaAccesoRepository auditoriaRepository) {
        this.usuarioRepository = usuarioRepository;
        this.emergenciaRepository = emergenciaRepository;
        this.notificacionRepository = notificacionRepository;
        this.auditoriaRepository = auditoriaRepository;
    }

    @Transactional(readOnly = true)
    public AdminStatsDto getDashboardStats() {
        AdminStatsDto stats = new AdminStatsDto();
        stats.setTotalUsuarios(usuarioRepository.count());
        stats.setUsuariosVerificados(usuarioRepository.count()); // Simplificado para DEV

        stats.setEmergenciasActivas(emergenciaRepository.countByEstadoIn(List.of("CREADA", "ACTIVA", "AYUDA_SOLICITADA", "EN_ATENCION")));

        OffsetDateTime startOfDay = OffsetDateTime.now().truncatedTo(ChronoUnit.DAYS);
        stats.setEmergenciasHoy(emergenciaRepository.countByFechaInicioAfter(startOfDay));

        OffsetDateTime startOfMonth = startOfDay.withDayOfMonth(1);
        stats.setEmergenciasMes(emergenciaRepository.countByFechaInicioAfter(startOfMonth));

        stats.setFalsasAlarmas(emergenciaRepository.countByEstado("FALSA_ALARMA"));
        stats.setNotificacionesFallidas(notificacionRepository.countByEstado("FALLIDO"));

        Map<String, Long> porTipo = new HashMap<>();
        List<Object[]> grouped = emergenciaRepository.countEmergenciesGroupedByType();
        for (Object[] row : grouped) {
            String tipo = (String) row[0];
            Long count = (Long) row[1];
            porTipo.put(tipo, count);
        }
        stats.setEmergenciasPorTipo(porTipo);

        return stats;
    }

    @Transactional(readOnly = true)
    public List<Emergencia> getActiveEmergencies() {
        return emergenciaRepository.findByEstadoInOrderByFechaInicioDesc(
                List.of("CREADA", "ACTIVA", "AYUDA_SOLICITADA", "EN_ATENCION")
        );
    }

    @Transactional(readOnly = true)
    public List<AuditoriaAcceso> getRecentAuditLogs() {
        return auditoriaRepository.findTop100ByOrderByTimestampDesc();
    }
}
