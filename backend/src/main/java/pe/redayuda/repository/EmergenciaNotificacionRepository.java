package pe.redayuda.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import pe.redayuda.entity.EmergenciaNotificacion;

import java.util.List;
import java.util.UUID;

@Repository
public interface EmergenciaNotificacionRepository extends JpaRepository<EmergenciaNotificacion, UUID> {
    List<EmergenciaNotificacion> findByEmergenciaIdOrderByTimestampDesc(UUID emergenciaId);
    long countByEstado(String estado);
}
