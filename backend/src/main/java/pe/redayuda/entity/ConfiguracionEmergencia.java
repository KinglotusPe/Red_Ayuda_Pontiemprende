package pe.redayuda.entity;

import jakarta.persistence.*;
import java.util.UUID;

@Entity
@Table(name = "configuracion_emergencia")
public class ConfiguracionEmergencia {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "usuario_id", nullable = false, unique = true)
    private Usuario usuario;

    @Column(name = "segundos_cuenta_regresiva", nullable = false)
    private Integer segundosCuentaRegresiva = 10;

    @Column(name = "duracion_audio_segundos", nullable = false)
    private Integer duracionAudioSegundos = 5;

    @Column(name = "sonido_cuenta_regresiva", nullable = false)
    private Boolean sonidoCuentaRegresiva = true;

    @Column(name = "vibracion_activa", nullable = false)
    private Boolean vibracionActiva = true;

    @Column(name = "activacion_voz_activa", nullable = false)
    private Boolean activacionVozActiva = false;

    @Column(name = "frase_activacion_voz", length = 100)
    private String fraseActivacionVoz = "RED AYUDA";

    public ConfiguracionEmergencia() {}

    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public Usuario getUsuario() { return usuario; }
    public void setUsuario(Usuario usuario) { this.usuario = usuario; }

    public Integer getSegundosCuentaRegresiva() { return segundosCuentaRegresiva; }
    public void setSegundosCuentaRegresiva(Integer segundosCuentaRegresiva) { this.segundosCuentaRegresiva = segundosCuentaRegresiva; }

    public Integer getDuracionAudioSegundos() { return duracionAudioSegundos; }
    public void setDuracionAudioSegundos(Integer duracionAudioSegundos) { this.duracionAudioSegundos = duracionAudioSegundos; }

    public Boolean getSonidoCuentaRegresiva() { return sonidoCuentaRegresiva; }
    public void setSonidoCuentaRegresiva(Boolean sonidoCuentaRegresiva) { this.sonidoCuentaRegresiva = sonidoCuentaRegresiva; }

    public Boolean getVibracionActiva() { return vibracionActiva; }
    public void setVibracionActiva(Boolean vibracionActiva) { this.vibracionActiva = vibracionActiva; }

    public Boolean getActivacionVozActiva() { return activacionVozActiva; }
    public void setActivacionVozActiva(Boolean activacionVozActiva) { this.activacionVozActiva = activacionVozActiva; }

    public String getFraseActivacionVoz() { return fraseActivacionVoz; }
    public void setFraseActivacionVoz(String fraseActivacionVoz) { this.fraseActivacionVoz = fraseActivacionVoz; }
}
