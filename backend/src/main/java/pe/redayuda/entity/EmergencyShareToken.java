package pe.redayuda.entity;

import jakarta.persistence.*;
import java.time.OffsetDateTime;
import java.util.UUID;

@Entity
@Table(name = "emergency_share_tokens")
public class EmergencyShareToken {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(nullable = false, unique = true, length = 128)
    private String token;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "emergencia_id", nullable = false)
    private Emergencia emergencia;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "contacto_id")
    private ContactoConfianza contacto;

    @Column(name = "permite_ubicacion_precisa", nullable = false)
    private Boolean permiteUbicacionPrecisa = true;

    @Column(name = "permite_audio", nullable = false)
    private Boolean permiteAudio = true;

    @Column(name = "expira_en", nullable = false)
    private OffsetDateTime expiraEn;

    @Column(nullable = false)
    private Boolean revocado = false;

    @Column(name = "fecha_creacion", updatable = false)
    private OffsetDateTime fechaCreacion = OffsetDateTime.now();

    public EmergencyShareToken() {}

    public boolean isValido() {
        return !revocado && expiraEn.isAfter(OffsetDateTime.now());
    }

    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public String getToken() { return token; }
    public void setToken(String token) { this.token = token; }

    public Emergencia getEmergencia() { return emergencia; }
    public void setEmergencia(Emergencia emergencia) { this.emergencia = emergencia; }

    public ContactoConfianza getContacto() { return contacto; }
    public void setContacto(ContactoConfianza contacto) { this.contacto = contacto; }

    public Boolean getPermiteUbicacionPrecisa() { return permiteUbicacionPrecisa; }
    public void setPermiteUbicacionPrecisa(Boolean permiteUbicacionPrecisa) { this.permiteUbicacionPrecisa = permiteUbicacionPrecisa; }

    public Boolean getPermiteAudio() { return permiteAudio; }
    public void setPermiteAudio(Boolean permiteAudio) { this.permiteAudio = permiteAudio; }

    public OffsetDateTime getExpiraEn() { return expiraEn; }
    public void setExpiraEn(OffsetDateTime expiraEn) { this.expiraEn = expiraEn; }

    public Boolean getRevocado() { return revocado; }
    public void setRevocado(Boolean revocado) { this.revocado = revocado; }

    public OffsetDateTime getFechaCreacion() { return fechaCreacion; }
    public void setFechaCreacion(OffsetDateTime fechaCreacion) { this.fechaCreacion = fechaCreacion; }
}
