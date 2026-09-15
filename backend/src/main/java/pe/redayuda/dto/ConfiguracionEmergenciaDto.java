package pe.redayuda.dto;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;

public class ConfiguracionEmergenciaDto {

    @Min(value = 3, message = "La cuenta regresiva mínima es de 3 segundos")
    @Max(value = 30, message = "La cuenta regresiva máxima es de 30 segundos")
    private Integer segundosCuentaRegresiva = 10;

    @Min(value = 5, message = "La duración de audio mínima es de 5 segundos")
    @Max(value = 30, message = "La duración de audio máxima es de 30 segundos")
    private Integer duracionAudioSegundos = 5;

    private Boolean sonidoCuentaRegresiva = true;
    private Boolean vibracionActiva = true;
    private Boolean activacionVozActiva = false;
    private String fraseActivacionVoz = "RED AYUDA";

    public ConfiguracionEmergenciaDto() {}

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
