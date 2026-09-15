package pe.redayuda.storage;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@Service
@ConditionalOnProperty(name = "app.storage.type", havingValue = "local", matchIfMissing = true)
public class LocalAudioStorageService implements AudioStorageService {

    private final Path storagePath;
    private final String baseUrl;

    public LocalAudioStorageService(
            @Value("${app.storage.local.upload-dir:./storage/audios}") String uploadDir,
            @Value("${app.base-url:http://localhost:8080}") String baseUrl) throws IOException {
        this.storagePath = Paths.get(uploadDir).toAbsolutePath().normalize();
        this.baseUrl = baseUrl;
        Files.createDirectories(this.storagePath);
    }

    @Override
    public String uploadAudio(String emergencyId, MultipartFile file) throws IOException {
        String originalFilename = file.getOriginalFilename();
        String extension = ".m4a";
        if (originalFilename != null && originalFilename.contains(".")) {
            extension = originalFilename.substring(originalFilename.lastIndexOf("."));
        }

        String storageKey = "emergency_" + emergencyId + "_" + UUID.randomUUID() + extension;
        Path targetLocation = this.storagePath.resolve(storageKey);
        Files.copy(file.getInputStream(), targetLocation, StandardCopyOption.REPLACE_EXISTING);

        return storageKey;
    }

    @Override
    public String generatePreSignedUrl(String storageKey, int expirationMinutes) {
        // En entorno local, genera un enlace temporal hacia el controlador de streaming con token
        long expiresAt = System.currentTimeMillis() + (expirationMinutes * 60L * 1000L);
        return baseUrl + "/api/v1/public/audio/" + storageKey + "?expires=" + expiresAt;
    }

    @Override
    public byte[] getAudioBytes(String storageKey) throws IOException {
        Path filePath = this.storagePath.resolve(storageKey).normalize();
        if (!filePath.startsWith(this.storagePath) || !Files.exists(filePath)) {
            throw new IOException("Archivo de audio no encontrado: " + storageKey);
        }
        return Files.readAllBytes(filePath);
    }
}
