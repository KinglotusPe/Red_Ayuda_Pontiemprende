package pe.redayuda.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import pe.redayuda.entity.ConfiguracionEmergencia;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface ConfiguracionEmergenciaRepository extends JpaRepository<ConfiguracionEmergencia, UUID> {
    Optional<ConfiguracionEmergencia> findByUsuarioId(UUID usuarioId);
}
