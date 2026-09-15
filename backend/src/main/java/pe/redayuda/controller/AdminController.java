package pe.redayuda.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import pe.redayuda.dto.AdminStatsDto;
import pe.redayuda.dto.DirectoryItemDto;
import pe.redayuda.entity.AuditoriaAcceso;
import pe.redayuda.entity.Emergencia;
import pe.redayuda.service.AdminService;
import pe.redayuda.service.DirectoryService;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/admin")
@PreAuthorize("hasAuthority('ROLE_ADMINISTRADOR')")
@Tag(name = "Panel Administrativo", description = "Endpoints de administración, estadísticas y auditoría")
public class AdminController {

    private final AdminService adminService;
    private final DirectoryService directoryService;

    public AdminController(AdminService adminService, DirectoryService directoryService) {
        this.adminService = adminService;
        this.directoryService = directoryService;
    }

    @GetMapping("/stats")
    @Operation(summary = "Métricas y estadísticas agregadas del sistema")
    public ResponseEntity<AdminStatsDto> getStats() {
        return ResponseEntity.ok(adminService.getDashboardStats());
    }

    @GetMapping("/emergencies")
    @Operation(summary = "Listado de emergencias activas para el mapa del centro de control")
    public ResponseEntity<List<Emergencia>> getActiveEmergencies() {
        return ResponseEntity.ok(adminService.getActiveEmergencies());
    }

    @PutMapping("/directory/{id}")
    @Operation(summary = "Actualizar teléfonos y datos del directorio oficial")
    public ResponseEntity<DirectoryItemDto> updateDirectoryItem(
            @PathVariable UUID id,
            @RequestBody DirectoryItemDto dto) {
        return ResponseEntity.ok(directoryService.updateDirectoryItem(id, dto));
    }

    @GetMapping("/audit")
    @Operation(summary = "Consultar los últimos 100 registros de auditoría de seguridad")
    public ResponseEntity<List<AuditoriaAcceso>> getAuditLogs() {
        return ResponseEntity.ok(adminService.getRecentAuditLogs());
    }
}
