package pe.redayuda.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import pe.redayuda.entity.EmergenciaUbicacion;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface EmergenciaUbicacionRepository extends JpaRepository<EmergenciaUbicacion, UUID> {
    List<EmergenciaUbicacion> findByEmergenciaIdOrderByTimestampAsc(UUID emergenciaId);
    Optional<EmergenciaUbicacion> findFirstByEmergenciaIdOrderByTimestampDesc(UUID emergenciaId);
}
