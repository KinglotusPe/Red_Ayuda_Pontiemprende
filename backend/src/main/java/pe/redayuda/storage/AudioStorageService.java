package pe.redayuda.storage;

import org.springframework.web.multipart.MultipartFile;
import java.io.IOException;

public interface AudioStorageService {

    /**
     * Sube el audio grabado al almacenamiento privado.
     * @return Clave única de almacenamiento (storage key).
     */
    String uploadAudio(String emergencyId, MultipartFile file) throws IOException;

    /**
     * Genera una URL firmada de acceso temporal (Pre-signed URL) de 15 minutos.
     */
    String generatePreSignedUrl(String storageKey, int expirationMinutes);

    /**
     * Obtiene los bytes del archivo (para stream o proxy local si aplica).
     */
    byte[] getAudioBytes(String storageKey) throws IOException;
}
