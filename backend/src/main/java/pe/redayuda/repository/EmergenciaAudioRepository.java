package pe.redayuda.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import pe.redayuda.entity.EmergenciaAudio;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface EmergenciaAudioRepository extends JpaRepository<EmergenciaAudio, UUID> {
    List<EmergenciaAudio> findByEmergenciaIdOrderByFechaGrabacionDesc(UUID emergenciaId);
    Optional<EmergenciaAudio> findFirstByEmergenciaIdOrderByFechaGrabacionDesc(UUID emergenciaId);
}
