package pe.redayuda.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import pe.redayuda.entity.EmergencyShareToken;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface EmergencyShareTokenRepository extends JpaRepository<EmergencyShareToken, UUID> {
    Optional<EmergencyShareToken> findByToken(String token);
}
