package pe.redayuda.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import pe.redayuda.entity.EmergenciaEvento;

import java.util.List;
import java.util.UUID;

@Repository
public interface EmergenciaEventoRepository extends JpaRepository<EmergenciaEvento, UUID> {
    List<EmergenciaEvento> findByEmergenciaIdOrderByTimestampAsc(UUID emergenciaId);
}
