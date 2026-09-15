package pe.redayuda.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import pe.redayuda.entity.ContactoConfianza;

import java.util.List;
import java.util.UUID;

@Repository
public interface ContactoConfianzaRepository extends JpaRepository<ContactoConfianza, UUID> {
    List<ContactoConfianza> findByUsuarioIdAndActivoTrueOrderByPrioridadAsc(UUID usuarioId);
    long countByUsuarioIdAndActivoTrue(UUID usuarioId);
}
