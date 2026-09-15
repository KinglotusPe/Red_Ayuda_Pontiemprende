package pe.redayuda.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import pe.redayuda.dto.ContactRequest;
import pe.redayuda.dto.ContactResponse;
import pe.redayuda.security.UserDetailsImpl;
import pe.redayuda.service.ContactService;

import java.util.List;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/contacts")
@Tag(name = "Contactos de Confianza", description = "Endpoints para administración de hasta 5 contactos de auxilio")
public class ContactController {

    private final ContactService contactService;

    public ContactController(ContactService contactService) {
        this.contactService = contactService;
    }

    @GetMapping
    @Operation(summary = "Listar contactos de confianza del usuario")
    public ResponseEntity<List<ContactResponse>> getContacts(@AuthenticationPrincipal UserDetailsImpl userDetails) {
        return ResponseEntity.ok(contactService.getContactsByUser(userDetails.getId()));
    }

    @PostMapping
    @Operation(summary = "Registrar un nuevo contacto de confianza (máximo 5)")
    public ResponseEntity<ContactResponse> addContact(
            @AuthenticationPrincipal UserDetailsImpl userDetails,
            @Valid @RequestBody ContactRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(contactService.addContact(userDetails.getId(), request));
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar contacto de confianza")
    public ResponseEntity<ContactResponse> updateContact(
            @PathVariable UUID id,
            @AuthenticationPrincipal UserDetailsImpl userDetails,
            @Valid @RequestBody ContactRequest request) {
        return ResponseEntity.ok(contactService.updateContact(userDetails.getId(), id, request));
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Eliminar contacto de confianza")
    public ResponseEntity<Map<String, String>> deleteContact(
            @PathVariable UUID id,
            @AuthenticationPrincipal UserDetailsImpl userDetails) {
        contactService.deleteContact(userDetails.getId(), id);
        return ResponseEntity.ok(Map.of("message", "Contacto eliminado exitosamente"));
    }
}
