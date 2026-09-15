package pe.redayuda.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.redayuda.dto.DirectoryItemDto;
import pe.redayuda.entity.DirectorioEmergencia;
import pe.redayuda.exception.ResourceNotFoundException;
import pe.redayuda.repository.DirectorioEmergenciaRepository;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class DirectoryService {

    private final DirectorioEmergenciaRepository directorioRepository;

    public DirectoryService(DirectorioEmergenciaRepository directorioRepository) {
        this.directorioRepository = directorioRepository;
    }

    @Transactional(readOnly = true)
    public List<DirectoryItemDto> getDirectory(String region, String tipo) {
        List<DirectorioEmergencia> items;
        if (region != null && !region.isBlank()) {
            items = directorioRepository.findByRegionIgnoreCaseAndActivoTrueOrderByPrioridadAsc(region);
        } else if (tipo != null && !tipo.isBlank()) {
            items = directorioRepository.findByTipoIgnoreCaseAndActivoTrueOrderByPrioridadAsc(tipo);
        } else {
            items = directorioRepository.findByActivoTrueOrderByPrioridadAsc();
        }

        return items.stream().map(this::mapToDto).collect(Collectors.toList());
    }

    @Transactional
    public DirectoryItemDto updateDirectoryItem(UUID id, DirectoryItemDto dto) {
        DirectorioEmergencia item = directorioRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Registro de directorio no encontrado"));

        item.setNombre(dto.getNombre());
        item.setTipo(dto.getTipo());
        item.setTelefono(dto.getTelefono());
        item.setRegion(dto.getRegion());
        item.setProvincia(dto.getProvincia());
        item.setDistrito(dto.getDistrito());
        item.setPrioridad(dto.getPrioridad());
        item.setFechaVerificacion(OffsetDateTime.now());

        return mapToDto(directorioRepository.save(item));
    }

    private DirectoryItemDto mapToDto(DirectorioEmergencia d) {
        return new DirectoryItemDto(
                d.getId(),
                d.getNombre(),
                d.getTipo(),
                d.getTelefono(),
                d.getRegion(),
                d.getProvincia(),
                d.getDistrito(),
                d.getPrioridad()
        );
    }
}
