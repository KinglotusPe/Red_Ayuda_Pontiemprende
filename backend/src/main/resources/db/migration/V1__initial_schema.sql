-- ============================================================
-- RED AYUDA — ESQUEMA INICIAL DE BASE DE DATOS POSTGRESQL (V1)
-- ============================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. TABLA DE USUARIOS
CREATE TABLE IF NOT EXISTS usuarios (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    dni VARCHAR(12) NOT NULL UNIQUE,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    pin_hash VARCHAR(255),
    pin_coercion_hash VARCHAR(255),
    fecha_nacimiento DATE,
    estado_verificacion VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE',
    estado VARCHAR(20) NOT NULL DEFAULT 'NORMAL',
    fecha_creacion TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_usuarios_dni ON usuarios(dni);
CREATE INDEX IF NOT EXISTS idx_usuarios_email ON usuarios(email);

-- 2. TABLA DE ROLES
CREATE TABLE IF NOT EXISTS roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre VARCHAR(50) NOT NULL UNIQUE
);

-- 3. TABLA INTERMEDIA USUARIOS_ROLES
CREATE TABLE IF NOT EXISTS usuario_roles (
    usuario_id UUID NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    rol_id UUID NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    PRIMARY KEY (usuario_id, rol_id)
);

-- 4. DISPOSITIVOS MÓVILES REGISTRADOS
CREATE TABLE IF NOT EXISTS dispositivos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    fcm_token VARCHAR(512),
    plataforma VARCHAR(20) NOT NULL, -- ANDROID, IOS
    modelo VARCHAR(100),
    version_so VARCHAR(50),
    ultima_conexion TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_dispositivos_usuario ON dispositivos(usuario_id);

-- 5. REFRESH TOKENS (REVOCABLES)
CREATE TABLE IF NOT EXISTS refresh_tokens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    token VARCHAR(512) NOT NULL UNIQUE,
    expira_en TIMESTAMP WITH TIME ZONE NOT NULL,
    revocado BOOLEAN DEFAULT FALSE,
    fecha_creacion TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_refresh_tokens_token ON refresh_tokens(token);

-- 6. CONTACTOS DE CONFIANZA (MÁXIMO 5 POR USUARIO)
CREATE TABLE IF NOT EXISTS contactos_confianza (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    email VARCHAR(150),
    parentesco VARCHAR(50),
    prioridad SMALLINT NOT NULL DEFAULT 1,
    tiene_red_ayuda BOOLEAN DEFAULT FALSE,
    usuario_red_ayuda_id UUID REFERENCES usuarios(id) ON DELETE SET NULL,
    permite_ubicacion_precisa BOOLEAN DEFAULT TRUE,
    permite_audio BOOLEAN DEFAULT TRUE,
    activo BOOLEAN DEFAULT TRUE,
    fecha_creacion TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_contactos_usuario ON contactos_confianza(usuario_id);

-- 7. CONFIGURACIÓN SOS POR USUARIO
CREATE TABLE IF NOT EXISTS configuracion_emergencia (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID NOT NULL UNIQUE REFERENCES usuarios(id) ON DELETE CASCADE,
    segundos_cuenta_regresiva INT NOT NULL DEFAULT 10,
    duracion_audio_segundos INT NOT NULL DEFAULT 5,
    sonido_cuenta_regresiva BOOLEAN DEFAULT TRUE,
    vibracion_activa BOOLEAN DEFAULT TRUE,
    activacion_voz_activa BOOLEAN DEFAULT FALSE,
    frase_activacion_voz VARCHAR(100) DEFAULT 'RED AYUDA'
);

-- 8. EMERGENCIAS
CREATE TABLE IF NOT EXISTS emergencias (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID NOT NULL REFERENCES usuarios(id),
    tipo VARCHAR(30) NOT NULL, -- ROBO, AGRESION, ACOSO, ACCIDENTE, etc.
    estado VARCHAR(30) NOT NULL DEFAULT 'CREADA', -- CREADA, ACTIVA, AYUDA_SOLICITADA, EN_ATENCION, RESUELTA, CANCELADA, FALSA_ALARMA
    posible_coaccion BOOLEAN DEFAULT FALSE,
    nivel_bateria SMALLINT,
    dispositivo_offline BOOLEAN DEFAULT FALSE,
    motivo_cancelacion TEXT,
    cancelado_por_usuario_id UUID REFERENCES usuarios(id),
    fecha_inicio TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    fecha_cierre TIMESTAMP WITH TIME ZONE
);

CREATE INDEX IF NOT EXISTS idx_emergencias_usuario ON emergencias(usuario_id);
CREATE INDEX IF NOT EXISTS idx_emergencias_estado ON emergencias(estado);
CREATE INDEX IF NOT EXISTS idx_emergencias_fecha ON emergencias(fecha_inicio);

-- 9. HISTORIAL DE UBICACIONES REDUNDANTES DE EMERGENCIA
CREATE TABLE IF NOT EXISTS emergencia_ubicaciones (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    emergencia_id UUID NOT NULL REFERENCES emergencias(id) ON DELETE CASCADE,
    latitud DOUBLE PRECISION NOT NULL,
    longitud DOUBLE PRECISION NOT NULL,
    precision_metros DOUBLE PRECISION,
    fuente VARCHAR(30) NOT NULL, -- GPS, PRECISE_SYSTEM, NETWORK, APPROXIMATE, LAST_KNOWN, UNKNOWN
    estado_movimiento VARCHAR(30) DEFAULT 'QUIETO', -- QUIETO, DESPLAZAMIENTO, MOVIMIENTO_RAPIDO
    velocidad_kmh DOUBLE PRECISION,
    es_inicial BOOLEAN DEFAULT FALSE,
    es_ultima_conocida BOOLEAN DEFAULT FALSE,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_ubicaciones_emergencia ON emergencia_ubicaciones(emergencia_id);

-- 10. AUDIOS DE EMERGENCIA PRIVADOS
CREATE TABLE IF NOT EXISTS emergencia_audios (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    emergencia_id UUID NOT NULL REFERENCES emergencias(id) ON DELETE CASCADE,
    storage_key VARCHAR(255) NOT NULL,
    duracion_segundos INT NOT NULL,
    tamano_bytes BIGINT NOT NULL,
    formato VARCHAR(20) DEFAULT 'audio/aac',
    estado_subida VARCHAR(30) DEFAULT 'SUBIDO',
    fecha_grabacion TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_audios_emergencia ON emergencia_audios(emergencia_id);

-- 11. EVENTOS INMUTABLES DE EMERGENCIA (TIMELINE AUDITABLE)
CREATE TABLE IF NOT EXISTS emergencia_eventos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    emergencia_id UUID NOT NULL REFERENCES emergencias(id) ON DELETE CASCADE,
    tipo_evento VARCHAR(50) NOT NULL,
    metadata_json TEXT,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_eventos_emergencia ON emergencia_eventos(emergencia_id);

-- 12. NOTIFICACIONES DESPACHADAS (HISTORIAL MULTICANAL)
CREATE TABLE IF NOT EXISTS emergencia_notificaciones (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    emergencia_id UUID NOT NULL REFERENCES emergencias(id) ON DELETE CASCADE,
    contacto_id UUID REFERENCES contactos_confianza(id) ON DELETE SET NULL,
    canal VARCHAR(20) NOT NULL, -- PUSH, SMS, WHATSAPP, EMAIL
    destinatario VARCHAR(150) NOT NULL,
    proveedor VARCHAR(50) NOT NULL,
    estado VARCHAR(30) NOT NULL, -- ENVIADO, FALLIDO, SIMULADO_DEV
    intentos INT DEFAULT 1,
    error TEXT,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_notif_emergencia ON emergencia_notificaciones(emergencia_id);

-- 13. TOKENS PÚBLICOS DE SEGUIMIENTO SEGURO (PARA CONTACTOS SIN APP)
CREATE TABLE IF NOT EXISTS emergency_share_tokens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    token VARCHAR(128) NOT NULL UNIQUE,
    emergencia_id UUID NOT NULL REFERENCES emergencias(id) ON DELETE CASCADE,
    contacto_id UUID REFERENCES contactos_confianza(id) ON DELETE SET NULL,
    permite_ubicacion_precisa BOOLEAN DEFAULT TRUE,
    permite_audio BOOLEAN DEFAULT TRUE,
    expira_en TIMESTAMP WITH TIME ZONE NOT NULL,
    revocado BOOLEAN DEFAULT FALSE,
    fecha_creacion TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_share_tokens_token ON emergency_share_tokens(token);

-- 14. DIRECTORIO TELEFÓNICO OFICIAL DE EMERGENCIAS
CREATE TABLE IF NOT EXISTS directorio_emergencia (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre VARCHAR(100) NOT NULL,
    tipo VARCHAR(30) NOT NULL, -- POLICIA, SAMU, BOMBEROS, SERENAZGO, HOSPITAL, DEFENSA_CIVIL
    telefono VARCHAR(20) NOT NULL,
    region VARCHAR(50) NOT NULL DEFAULT 'Ayacucho',
    provincia VARCHAR(50) NOT NULL DEFAULT 'Huamanga',
    distrito VARCHAR(50) NOT NULL DEFAULT 'Ayacucho',
    prioridad SMALLINT DEFAULT 1,
    activo BOOLEAN DEFAULT TRUE,
    fuente_verificacion VARCHAR(100),
    fecha_verificacion TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 15. AUDITORÍA DE ACCIONES CRÍTICAS
CREATE TABLE IF NOT EXISTS auditoria_accesos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID REFERENCES usuarios(id) ON DELETE SET NULL,
    accion VARCHAR(100) NOT NULL,
    recurso VARCHAR(100),
    ip_origen VARCHAR(45),
    user_agent VARCHAR(255),
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
