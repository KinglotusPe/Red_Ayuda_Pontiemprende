package pe.redayuda.audit;

import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.redayuda.entity.AuditoriaAcceso;
import pe.redayuda.repository.AuditoriaAccesoRepository;

import java.util.UUID;

@Service
public class AuditService {

    private final AuditoriaAccesoRepository auditoriaRepository;

    public AuditService(AuditoriaAccesoRepository auditoriaRepository) {
        this.auditoriaRepository = auditoriaRepository;
    }

    @Async
    @Transactional
    public void logAction(UUID usuarioId, String accion, String recurso, String ipOrigen, String userAgent) {
        AuditoriaAcceso auditoria = new AuditoriaAcceso(usuarioId, accion, recurso, ipOrigen, userAgent);
        auditoriaRepository.save(auditoria);
    }
}
