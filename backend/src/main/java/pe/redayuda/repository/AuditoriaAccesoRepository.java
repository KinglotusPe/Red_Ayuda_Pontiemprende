package pe.redayuda.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import pe.redayuda.entity.AuditoriaAcceso;

import java.util.List;
import java.util.UUID;

@Repository
public interface AuditoriaAccesoRepository extends JpaRepository<AuditoriaAcceso, UUID> {
    List<AuditoriaAcceso> findTop100ByOrderByTimestampDesc();
}
