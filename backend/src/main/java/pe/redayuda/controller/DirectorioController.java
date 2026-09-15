package pe.redayuda.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import pe.redayuda.dto.DirectoryItemDto;
import pe.redayuda.service.DirectoryService;

import java.util.List;

@RestController
@RequestMapping("/api/v1/directory")
@Tag(name = "Directorio Oficial", description = "Directorio de emergencias públicas (105, 106, 116, Serenazgo)")
public class DirectorioController {

    private final DirectoryService directoryService;

    public DirectorioController(DirectoryService directoryService) {
        this.directoryService = directoryService;
    }

    @GetMapping
    @Operation(summary = "Obtener directorio de teléfonos de emergencia oficiales")
    public ResponseEntity<List<DirectoryItemDto>> getDirectory(
            @RequestParam(required = false, defaultValue = "Ayacucho") String region,
            @RequestParam(required = false) String tipo) {
        return ResponseEntity.ok(directoryService.getDirectory(region, tipo));
    }
}
