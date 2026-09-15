package pe.redayuda.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import pe.redayuda.dto.*;
import pe.redayuda.security.UserDetailsImpl;
import pe.redayuda.service.AuthService;

import java.util.Map;

@RestController
@RequestMapping("/api/v1/auth")
@Tag(name = "Autenticación", description = "Endpoints de registro, login, refresh tokens y configuración de PIN")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/register")
    @Operation(summary = "Registrar nuevo ciudadano")
    public ResponseEntity<AuthResponse> register(@Valid @RequestBody RegisterRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(authService.register(request));
    }

    @PostMapping("/login")
    @Operation(summary = "Iniciar sesión")
    public ResponseEntity<AuthResponse> login(@Valid @RequestBody LoginRequest request) {
        return ResponseEntity.ok(authService.login(request));
    }

    @PostMapping("/refresh-token")
    @Operation(summary = "Renovar Access Token mediante Refresh Token")
    public ResponseEntity<AuthResponse> refreshToken(@Valid @RequestBody RefreshTokenRequest request) {
        return ResponseEntity.ok(authService.refreshToken(request));
    }

    @PostMapping("/pin/setup")
    @Operation(summary = "Configurar PIN normal y PIN de coacción")
    public ResponseEntity<Map<String, String>> setupPin(
            @AuthenticationPrincipal UserDetailsImpl userDetails,
            @Valid @RequestBody SetupPinRequest request) {
        authService.setupPin(userDetails.getId(), request);
        return ResponseEntity.ok(Map.of("message", "PIN de seguridad configurado exitosamente"));
    }

    @PostMapping("/pin/verify")
    @Operation(summary = "Verificar validez del PIN")
    public ResponseEntity<Map<String, Boolean>> verifyPin(
            @AuthenticationPrincipal UserDetailsImpl userDetails,
            @Valid @RequestBody VerifyPinRequest request) {
        boolean valid = authService.verifyPin(userDetails.getId(), request.getPin());
        return ResponseEntity.ok(Map.of("valid", valid));
    }
}
