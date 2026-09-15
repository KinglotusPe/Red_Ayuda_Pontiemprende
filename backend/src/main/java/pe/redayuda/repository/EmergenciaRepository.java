package pe.redayuda.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import pe.redayuda.entity.Emergencia;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface EmergenciaRepository extends JpaRepository<Emergencia, UUID> {

    List<Emergencia> findByUsuarioIdOrderByFechaInicioDesc(UUID usuarioId);

    Optional<Emergencia> findFirstByUsuarioIdAndEstadoInOrderByFechaInicioDesc(UUID usuarioId, List<String> estados);

    List<Emergencia> findByEstadoInOrderByFechaInicioDesc(List<String> estados);

    long countByEstadoIn(List<String> estados);

    long countByFechaInicioAfter(OffsetDateTime fecha);

    long countByEstado(String estado);

    @Query("SELECT e.tipo, COUNT(e) FROM Emergencia e GROUP BY e.tipo")
    List<Object[]> countEmergenciesGroupedByType();
}
