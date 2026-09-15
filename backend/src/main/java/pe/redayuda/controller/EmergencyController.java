package pe.redayuda.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import pe.redayuda.dto.*;
import pe.redayuda.security.UserDetailsImpl;
import pe.redayuda.service.EmergencyService;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/emergencies")
@Tag(name = "Emergencias", description = "Endpoints para activación SOS, tracking, audio y cancelación segura")
public class EmergencyController {

    private final EmergencyService emergencyService;

    public EmergencyController(EmergencyService emergencyService) {
        this.emergencyService = emergencyService;
    }

    @PostMapping("/sos")
    @Operation(summary = "Disparar alerta SOS inmediata tras finalizar cuenta regresiva")
    public ResponseEntity<EmergencyResponse> triggerSos(
            @AuthenticationPrincipal UserDetailsImpl userDetails,
            @Valid @RequestBody TriggerSosRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(emergencyService.triggerSos(userDetails.getId(), request));
    }

    @PostMapping("/{id}/location")
    @Operation(summary = "Actualizar coordenadas periódicas de tracking")
    public ResponseEntity<EmergencyResponse> updateLocation(
            @PathVariable UUID id,
            @Valid @RequestBody LocationUpdateRequest request) {
        return ResponseEntity.ok(emergencyService.updateLocation(id, request));
    }

    @PostMapping(value = "/{id}/audio", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Operation(summary = "Subir fragmento de audio ambiental capturado (5-10s)")
    public ResponseEntity<Map<String, String>> uploadAudio(
            @PathVariable UUID id,
            @RequestParam("audio") MultipartFile file,
            @RequestParam(value = "duracion", defaultValue = "5") int duracion) throws IOException {
        emergencyService.uploadAudio(id, file, duracion);
        return ResponseEntity.ok(Map.of("message", "Audio de emergencia subido con éxito"));
    }

    @PostMapping("/{id}/cancel")
    @Operation(summary = "Cancelar emergencia con PIN (valida PIN normal vs PIN de coacción)")
    public ResponseEntity<Map<String, Object>> cancelEmergency(
            @PathVariable UUID id,
            @AuthenticationPrincipal UserDetailsImpl userDetails,
            @Valid @RequestBody CancelEmergencyRequest request) {
        return ResponseEntity.ok(emergencyService.cancelEmergency(id, userDetails.getId(), request));
    }

    @PostMapping("/{id}/resolve")
    @Operation(summary = "Marcar emergencia como resuelta")
    public ResponseEntity<EmergencyResponse> resolveEmergency(
            @PathVariable UUID id,
            @AuthenticationPrincipal UserDetailsImpl userDetails) {
        return ResponseEntity.ok(emergencyService.resolveEmergency(id, userDetails.getId()));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Consultar detalle completo de una emergencia")
    public ResponseEntity<EmergencyResponse> getEmergencyDetail(
            @PathVariable UUID id,
            @AuthenticationPrincipal UserDetailsImpl userDetails) {
        return ResponseEntity.ok(emergencyService.getEmergencyDetail(id, userDetails.getId()));
    }

    @GetMapping("/history")
    @Operation(summary = "Consultar historial de emergencias del usuario autenticado")
    public ResponseEntity<List<EmergencyResponse>> getUserEmergencies(
            @AuthenticationPrincipal UserDetailsImpl userDetails) {
        return ResponseEntity.ok(emergencyService.getUserEmergencies(userDetails.getId()));
    }
}
