package pe.redayuda.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import pe.redayuda.dto.PublicEmergencyShareDto;
import pe.redayuda.exception.UnauthorizedException;
import pe.redayuda.service.ShareTokenService;
import pe.redayuda.storage.AudioStorageService;

import java.io.IOException;

@RestController
@RequestMapping("/api/v1/public")
@Tag(name = "Seguimiento Público Seguro", description = "Endpoints accesibles para contactos autorizados mediante tokens temporales")
public class PublicShareController {

    private final ShareTokenService shareTokenService;
    private final AudioStorageService audioStorageService;

    public PublicShareController(ShareTokenService shareTokenService, AudioStorageService audioStorageService) {
        this.shareTokenService = shareTokenService;
        this.audioStorageService = audioStorageService;
    }

    @GetMapping("/share/{token}")
    @Operation(summary = "Consultar datos de emergencia activa mediante token temporal seguro")
    public ResponseEntity<PublicEmergencyShareDto> getSharedEmergency(@PathVariable String token) {
        return ResponseEntity.ok(shareTokenService.getEmergencyByShareToken(token));
    }

    @GetMapping("/audio/{storageKey}")
    @Operation(summary = "Streaming seguro de fragmento de audio para contactos autorizados")
    public ResponseEntity<byte[]> streamAudio(
            @PathVariable String storageKey,
            @RequestParam("expires") long expires) throws IOException {

        if (System.currentTimeMillis() > expires) {
            throw new UnauthorizedException("El enlace de reproducción de audio ha expirado");
        }

        byte[] audioBytes = audioStorageService.getAudioBytes(storageKey);
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.parseMediaType("audio/aac"));
        headers.setContentLength(audioBytes.length);

        return new ResponseEntity<>(audioBytes, headers, HttpStatus.OK);
    }
}
