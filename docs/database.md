# Modelo de Datos y Base de Datos — RED AYUDA

## 1. Motor de Base de Datos
PostgreSQL 16 con extensión `uuid-ossp` y soporte para búsquedas geográficas. Migraciones versionadas gestionadas mediante **Flyway**.

## 2. Tablas Principales

### `usuarios`
Almacena las cuentas ciudadanas. El DNI y teléfonos son tratados como datos sensibles protegidos.
- `id` (UUID, PK)
- `dni` (VARCHAR(12), UNIQUE, sensible)
- `nombres` (VARCHAR(100))
- `apellidos` (VARCHAR(100))
- `telefono` (VARCHAR(20))
- `email` (VARCHAR(150), UNIQUE)
- `password_hash` (VARCHAR(255), BCrypt)
- `pin_hash` (VARCHAR(255), BCrypt)
- `pin_coercion_hash` (VARCHAR(255), BCrypt - PIN de coacción falso)
- `estado_verificacion` (VARCHAR(20): PENDIENTE, VERIFICADO, RECHAZADO)
- `estado` (VARCHAR(20): NORMAL, ADVERTIDO, RESTRINGIDO, SUSPENDIDO)
- `fecha_creacion`, `fecha_actualizacion`

### `contactos_confianza`
Hasta 5 contactos de auxilio por usuario. No están obligados a tener la app instalada.
- `id` (UUID, PK)
- `usuario_id` (UUID, FK -> usuarios)
- `nombre` (VARCHAR(100))
- `telefono` (VARCHAR(20))
- `email` (VARCHAR(150))
- `parentesco` (VARCHAR(50))
- `prioridad` (SMALLINT, 1 al 5)
- `tiene_red_ayuda` (BOOLEAN)
- `usuario_red_ayuda_id` (UUID, FK -> usuarios, opcional)
- `permite_ubicacion_precisa` (BOOLEAN)
- `permite_audio` (BOOLEAN)
- `activo` (BOOLEAN)

### `emergencias`
Registro central de cada incidente activado.
- `id` (UUID, PK)
- `usuario_id` (UUID, FK -> usuarios)
- `tipo` (VARCHAR(30): ROBO, AGRESION, ACOSO, ACCIDENTE, EMERGENCIA_MEDICA, PERSONA_DESAPARECIDA, INCENDIO, OTRA, DESCONOCIDA)
- `estado` (VARCHAR(30): CREADA, ACTIVA, AYUDA_SOLICITADA, EN_ATENCION, RESUELTA, CANCELADA, FALSA_ALARMA)
- `posible_coaccion` (BOOLEAN)
- `nivel_bateria` (SMALLINT)
- `dispositivo_offline` (BOOLEAN)
- `motivo_cancelacion` (TEXT)
- `fecha_inicio`, `fecha_cierre`

### `emergencia_ubicaciones`
Historial de tracking continuo redundante.
- `id` (UUID, PK)
- `emergencia_id` (UUID, FK -> emergencias)
- `latitud`, `longitud` (DOUBLE PRECISION)
- `precision_metros` (DOUBLE PRECISION)
- `fuente` (VARCHAR(30): GPS, PRECISE_SYSTEM, NETWORK, APPROXIMATE, LAST_KNOWN, UNKNOWN)
- `estado_movimiento` (VARCHAR(30): QUIETO, DESPLAZAMIENTO, MOVIMIENTO_RAPIDO)
- `velocidad_kmh` (DOUBLE PRECISION)
- `es_inicial`, `es_ultima_conocida` (BOOLEAN)

### `emergencia_audios`
Audios breves ambientales (5-10s) con acceso privado.
- `id` (UUID, PK)
- `emergencia_id` (UUID, FK -> emergencias)
- `storage_key` (VARCHAR(255))
- `duracion_segundos` (INT)
- `tamano_bytes` (BIGINT)
- `formato` (VARCHAR(20): audio/aac)
- `estado_subida` (VARCHAR(30))

### `emergencia_eventos`
Timeline inmutable para auditoría del incidente.
- `id` (UUID, PK)
- `emergencia_id` (UUID, FK -> emergencias)
- `tipo_evento` (VARCHAR(50): SOS_TRIGGERED, EMERGENCY_CREATED, LOCATION_RECEIVED, LOCATION_IMPROVED, CONTACT_NOTIFIED, COERCION_PIN_USED, etc.)
- `metadata_json` (TEXT)
- `timestamp` (TIMESTAMP WITH TIME ZONE)

### `emergency_share_tokens`
Tokens criptográficos para visualización web sin app.
- `id` (UUID, PK)
- `token` (VARCHAR(128), UNIQUE)
- `emergencia_id` (UUID, FK -> emergencias)
- `contacto_id` (UUID, FK -> contactos_confianza)
- `permite_ubicacion_precisa` (BOOLEAN)
- `permite_audio` (BOOLEAN)
- `expira_en` (TIMESTAMP WITH TIME ZONE)
- `revocado` (BOOLEAN)

### `directorio_emergencia`
Teléfonos oficiales configurables (Policía 105, SAMU 106, Bomberos 116, Serenazgo).
