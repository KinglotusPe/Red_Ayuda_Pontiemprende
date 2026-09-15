package pe.redayuda.service;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.redayuda.dto.*;
import pe.redayuda.entity.*;
import pe.redayuda.exception.BadRequestException;
import pe.redayuda.exception.UnauthorizedException;
import pe.redayuda.repository.*;
import pe.redayuda.security.JwtTokenProvider;

import java.time.OffsetDateTime;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class AuthService {

    private final UsuarioRepository usuarioRepository;
    private final RolRepository rolRepository;
    private final DispositivoRepository dispositivoRepository;
    private final RefreshTokenRepository refreshTokenRepository;
    private final ConfiguracionEmergenciaRepository configuracionRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtTokenProvider jwtTokenProvider;

    public AuthService(
            UsuarioRepository usuarioRepository,
            RolRepository rolRepository,
            DispositivoRepository dispositivoRepository,
            RefreshTokenRepository refreshTokenRepository,
            ConfiguracionEmergenciaRepository configuracionRepository,
            PasswordEncoder passwordEncoder,
            JwtTokenProvider jwtTokenProvider) {
        this.usuarioRepository = usuarioRepository;
        this.rolRepository = rolRepository;
        this.dispositivoRepository = dispositivoRepository;
        this.refreshTokenRepository = refreshTokenRepository;
        this.configuracionRepository = configuracionRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtTokenProvider = jwtTokenProvider;
    }

    @Transactional
    public AuthResponse register(RegisterRequest request) {
        if (usuarioRepository.existsByEmail(request.getEmail())) {
            throw new BadRequestException("El correo electrónico ya se encuentra registrado");
        }
        if (usuarioRepository.existsByDni(request.getDni())) {
            throw new BadRequestException("El DNI ya se encuentra registrado");
        }
        if (usuarioRepository.existsByTelefono(request.getTelefono())) {
            throw new BadRequestException("El número telefónico ya se encuentra registrado");
        }

        Usuario usuario = new Usuario();
        usuario.setDni(request.getDni());
        usuario.setNombres(request.getNombres());
        usuario.setApellidos(request.getApellidos());
        usuario.setTelefono(request.getTelefono());
        usuario.setEmail(request.getEmail());
        usuario.setPasswordHash(passwordEncoder.encode(request.getPassword()));
        usuario.setFechaNacimiento(request.getFechaNacimiento());
        usuario.setEstadoVerificacion("PENDIENTE");
        usuario.setEstado("NORMAL");

        Rol rolCiudadano = rolRepository.findByNombre("ROLE_CIUDADANO")
                .orElseGet(() -> rolRepository.save(new Rol("ROLE_CIUDADANO")));
        usuario.getRoles().add(rolCiudadano);

        Usuario savedUser = usuarioRepository.save(usuario);

        // Crear configuración SOS inicial por defecto
        ConfiguracionEmergencia config = new ConfiguracionEmergencia();
        config.setUsuario(savedUser);
        configuracionRepository.save(config);

        return generateAuthResponse(savedUser);
    }

    @Transactional
    public AuthResponse login(LoginRequest request) {
        Usuario usuario = usuarioRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new UnauthorizedException("Credenciales inválidas"));

        if (!passwordEncoder.matches(request.getPassword(), usuario.getPasswordHash())) {
            throw new UnauthorizedException("Credenciales inválidas");
        }

        if ("SUSPENDIDO".equalsIgnoreCase(usuario.getEstado())) {
            throw new UnauthorizedException("Esta cuenta se encuentra temporalmente suspendida");
        }

        // Registrar o actualizar dispositivo
        if (request.getPlataforma() != null) {
            Dispositivo dispositivo = new Dispositivo();
            dispositivo.setUsuario(usuario);
            dispositivo.setPlataforma(request.getPlataforma());
            dispositivo.setFcmToken(request.getFcmToken());
            dispositivo.setModelo(request.getModelo());
            dispositivo.setVersionSo(request.getVersionSo());
            dispositivo.setUltimaConexion(OffsetDateTime.now());
            dispositivoRepository.save(dispositivo);
        }

        return generateAuthResponse(usuario);
    }

    @Transactional
    public AuthResponse refreshToken(RefreshTokenRequest request) {
        RefreshToken refreshToken = refreshTokenRepository.findByTokenAndRevocadoFalse(request.getRefreshToken())
                .orElseThrow(() -> new UnauthorizedException("Refresh token inválido o revocado"));

        if (refreshToken.getExpiraEn().isBefore(OffsetDateTime.now())) {
            refreshToken.setRevocado(true);
            refreshTokenRepository.save(refreshToken);
            throw new UnauthorizedException("El refresh token ha expirado. Inicie sesión nuevamente.");
        }

        Usuario usuario = refreshToken.getUsuario();
        return generateAuthResponse(usuario);
    }

    @Transactional
    public void setupPin(UUID userId, SetupPinRequest request) {
        if (request.getPin().equals(request.getPinCoercion())) {
            throw new BadRequestException("El PIN de coacción debe ser estrictamente diferente al PIN normal por seguridad");
        }

        Usuario usuario = usuarioRepository.findById(userId)
                .orElseThrow(() -> new BadRequestException("Usuario no encontrado"));

        usuario.setPinHash(passwordEncoder.encode(request.getPin()));
        usuario.setPinCoercionHash(passwordEncoder.encode(request.getPinCoercion()));
        usuarioRepository.save(usuario);
    }

    @Transactional(readOnly = true)
    public boolean verifyPin(UUID userId, String pin) {
        Usuario usuario = usuarioRepository.findById(userId)
                .orElseThrow(() -> new BadRequestException("Usuario no encontrado"));

        if (usuario.getPinHash() == null) {
            throw new BadRequestException("El usuario aún no ha configurado su PIN de seguridad");
        }

        return passwordEncoder.matches(pin, usuario.getPinHash());
    }

    private AuthResponse generateAuthResponse(Usuario usuario) {
        String accessToken = jwtTokenProvider.generateAccessTokenFromUser(usuario.getId(), usuario.getEmail());

        // Generar refresh token
        RefreshToken refreshToken = new RefreshToken();
        refreshToken.setUsuario(usuario);
        refreshToken.setToken(UUID.randomUUID().toString() + "-" + UUID.randomUUID().toString());
        refreshToken.setExpiraEn(OffsetDateTime.now().plusDays(7));
        refreshTokenRepository.save(refreshToken);

        Set<String> roles = usuario.getRoles().stream().map(Rol::getNombre).collect(Collectors.toSet());
        boolean hasPin = usuario.getPinHash() != null && !usuario.getPinHash().isBlank();

        UserSummaryDto userSummary = new UserSummaryDto(
                usuario.getId(),
                usuario.getNombres(),
                usuario.getApellidos(),
                usuario.getEmail(),
                usuario.getTelefono(),
                roles,
                usuario.getEstadoVerificacion(),
                hasPin
        );

        return new AuthResponse(accessToken, refreshToken.getToken(), jwtTokenProvider.getExpirationMs(), userSummary);
    }
}
