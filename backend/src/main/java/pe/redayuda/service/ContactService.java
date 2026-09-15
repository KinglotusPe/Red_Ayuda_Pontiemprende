package pe.redayuda.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.redayuda.dto.ContactRequest;
import pe.redayuda.dto.ContactResponse;
import pe.redayuda.entity.ContactoConfianza;
import pe.redayuda.entity.Usuario;
import pe.redayuda.exception.BadRequestException;
import pe.redayuda.exception.ResourceNotFoundException;
import pe.redayuda.repository.ContactoConfianzaRepository;
import pe.redayuda.repository.UsuarioRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class ContactService {

    private final ContactoConfianzaRepository contactoRepository;
    private final UsuarioRepository usuarioRepository;

    public ContactService(ContactoConfianzaRepository contactoRepository, UsuarioRepository usuarioRepository) {
        this.contactoRepository = contactoRepository;
        this.usuarioRepository = usuarioRepository;
    }

    @Transactional(readOnly = true)
    public List<ContactResponse> getContactsByUser(UUID userId) {
        return contactoRepository.findByUsuarioIdAndActivoTrueOrderByPrioridadAsc(userId).stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    @Transactional
    public ContactResponse addContact(UUID userId, ContactRequest request) {
        long currentCount = contactoRepository.countByUsuarioIdAndActivoTrue(userId);
        if (currentCount >= 5) {
            throw new BadRequestException("Ha alcanzado el límite máximo de 5 contactos de emergencia permitidos");
        }

        Usuario usuario = usuarioRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("Usuario no encontrado"));

        ContactoConfianza contacto = new ContactoConfianza();
        contacto.setUsuario(usuario);
        contacto.setNombre(request.getNombre());
        contacto.setTelefono(request.getTelefono());
        contacto.setEmail(request.getEmail());
        contacto.setParentesco(request.getParentesco());
        contacto.setPrioridad(request.getPrioridad() != null ? request.getPrioridad() : (int) currentCount + 1);
        contacto.setPermiteUbicacionPrecisa(request.getPermiteUbicacionPrecisa() != null ? request.getPermiteUbicacionPrecisa() : true);
        contacto.setPermiteAudio(request.getPermiteAudio() != null ? request.getPermiteAudio() : true);
        contacto.setActivo(true);

        // Comprobar si el teléfono o email ya pertenece a un usuario de Red Ayuda
        Optional<Usuario> registeredContact = usuarioRepository.findByEmail(request.getEmail());
        if (registeredContact.isPresent()) {
            contacto.setTieneRedAyuda(true);
            contacto.setUsuarioRedAyuda(registeredContact.get());
        } else {
            contacto.setTieneRedAyuda(false);
        }

        ContactoConfianza saved = contactoRepository.save(contacto);
        return mapToResponse(saved);
    }

    @Transactional
    public ContactResponse updateContact(UUID userId, UUID contactId, ContactRequest request) {
        ContactoConfianza contacto = contactoRepository.findById(contactId)
                .orElseThrow(() -> new ResourceNotFoundException("Contacto no encontrado"));

        if (!contacto.getUsuario().getId().equals(userId)) {
            throw new BadRequestException("No tiene permisos para modificar este contacto");
        }

        contacto.setNombre(request.getNombre());
        contacto.setTelefono(request.getTelefono());
        contacto.setEmail(request.getEmail());
        contacto.setParentesco(request.getParentesco());
        if (request.getPrioridad() != null) contacto.setPrioridad(request.getPrioridad());
        if (request.getPermiteUbicacionPrecisa() != null) contacto.setPermiteUbicacionPrecisa(request.getPermiteUbicacionPrecisa());
        if (request.getPermiteAudio() != null) contacto.setPermiteAudio(request.getPermiteAudio());

        return mapToResponse(contactoRepository.save(contacto));
    }

    @Transactional
    public void deleteContact(UUID userId, UUID contactId) {
        ContactoConfianza contacto = contactoRepository.findById(contactId)
                .orElseThrow(() -> new ResourceNotFoundException("Contacto no encontrado"));

        if (!contacto.getUsuario().getId().equals(userId)) {
            throw new BadRequestException("No tiene permisos para eliminar este contacto");
        }

        contacto.setActivo(false);
        contactoRepository.save(contacto);
    }

    private ContactResponse mapToResponse(ContactoConfianza c) {
        ContactResponse r = new ContactResponse();
        r.setId(c.getId());
        r.setNombre(c.getNombre());
        r.setTelefono(c.getTelefono());
        r.setEmail(c.getEmail());
        r.setParentesco(c.getParentesco());
        r.setPrioridad(c.getPrioridad());
        r.setTieneRedAyuda(c.getTieneRedAyuda());
        r.setPermiteUbicacionPrecisa(c.getPermiteUbicacionPrecisa());
        r.setPermiteAudio(c.getPermiteAudio());
        r.setActivo(c.getActivo());
        return r;
    }
}
