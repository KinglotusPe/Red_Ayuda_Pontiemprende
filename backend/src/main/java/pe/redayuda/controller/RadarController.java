package pe.redayuda.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import pe.redayuda.dto.NearbyAlertDto;
import pe.redayuda.entity.Emergencia;
import pe.redayuda.location.GeoUtils;
import pe.redayuda.repository.EmergenciaRepository;
import pe.redayuda.repository.EmergenciaUbicacionRepository;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/v1/radar")
@Tag(name = "Radar Ciudadano", description = "Alertas anónimas para vecindarios cercanos sin revelar identidad ni audio")
public class RadarController {

    private final EmergenciaRepository emergenciaRepository;
    private final EmergenciaUbicacionRepository ubicacionRepository;
    private final GeoUtils geoUtils;

    public RadarController(
            EmergenciaRepository emergenciaRepository,
            EmergenciaUbicacionRepository ubicacionRepository,
            GeoUtils geoUtils) {
        this.emergenciaRepository = emergenciaRepository;
        this.ubicacionRepository = ubicacionRepository;
        this.geoUtils = geoUtils;
    }

    @GetMapping("/nearby-alerts")
    @Operation(summary = "Obtener alertas cercanas en el radio de protección")
    public ResponseEntity<List<NearbyAlertDto>> getNearbyAlerts(
            @RequestParam double lat,
            @RequestParam double lon,
            @RequestParam(defaultValue = "1500") double maxRadiusMeters) {

        List<Emergencia> activas = emergenciaRepository.findByEstadoInOrderByFechaInicioDesc(
                List.of("CREADA", "ACTIVA", "AYUDA_SOLICITADA", "EN_ATENCION")
        );

        List<NearbyAlertDto> resultado = new ArrayList<>();

        for (Emergencia e : activas) {
            ubicacionRepository.findFirstByEmergenciaIdOrderByTimestampDesc(e.getId()).ifPresent(loc -> {
                double distance = geoUtils.calculateDistanceMeters(lat, lon, loc.getLatitud(), loc.getLongitud());
                if (distance <= maxRadiusMeters) {
                    // Retornar ÚNICAMENTE datos no sensibles
                    resultado.add(new NearbyAlertDto(
                            e.getId(),
                            e.getTipo(),
                            Math.round(distance * 10.0) / 10.0,
                            "Zona Ayacucho Centro",
                            e.getFechaInicio(),
                            e.getEstado()
                    ));
                }
            });
        }

        return ResponseEntity.ok(resultado);
    }
}
