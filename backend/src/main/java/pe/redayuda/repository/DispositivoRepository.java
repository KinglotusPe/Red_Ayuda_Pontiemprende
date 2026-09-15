package pe.redayuda.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import pe.redayuda.entity.Dispositivo;

import java.util.List;
import java.util.UUID;

@Repository
public interface DispositivoRepository extends JpaRepository<Dispositivo, UUID> {
    List<Dispositivo> findByUsuarioId(UUID usuarioId);
}
