package pe.redayuda.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import pe.redayuda.entity.DirectorioEmergencia;

import java.util.List;
import java.util.UUID;

@Repository
public interface DirectorioEmergenciaRepository extends JpaRepository<DirectorioEmergencia, UUID> {
    List<DirectorioEmergencia> findByActivoTrueOrderByPrioridadAsc();
    List<DirectorioEmergencia> findByRegionIgnoreCaseAndActivoTrueOrderByPrioridadAsc(String region);
    List<DirectorioEmergencia> findByTipoIgnoreCaseAndActivoTrueOrderByPrioridadAsc(String tipo);
}
