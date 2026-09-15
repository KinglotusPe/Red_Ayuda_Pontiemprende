package pe.redayuda.entity;

import jakarta.persistence.*;
import java.time.OffsetDateTime;
import java.util.UUID;

@Entity
@Table(name = "dispositivos")
public class Dispositivo {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario;

    @Column(name = "fcm_token", length = 512)
    private String fcmToken;

    @Column(nullable = false, length = 20)
    private String plataforma; // ANDROID, IOS

    @Column(length = 100)
    private String modelo;

    @Column(name = "version_so", length = 50)
    private String versionSo;

    @Column(name = "ultima_conexion")
    private OffsetDateTime ultimaConexion = OffsetDateTime.now();

    public Dispositivo() {}

    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public Usuario getUsuario() { return usuario; }
    public void setUsuario(Usuario usuario) { this.usuario = usuario; }

    public String getFcmToken() { return fcmToken; }
    public void setFcmToken(String fcmToken) { this.fcmToken = fcmToken; }

    public String getPlataforma() { return plataforma; }
    public void setPlataforma(String plataforma) { this.plataforma = plataforma; }

    public String getModelo() { return modelo; }
    public void setModelo(String modelo) { this.modelo = modelo; }

    public String getVersionSo() { return versionSo; }
    public void setVersionSo(String versionSo) { this.versionSo = versionSo; }

    public OffsetDateTime getUltimaConexion() { return ultimaConexion; }
    public void setUltimaConexion(OffsetDateTime ultimaConexion) { this.ultimaConexion = ultimaConexion; }
}
