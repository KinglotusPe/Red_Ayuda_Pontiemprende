# PROMPT MAESTRO DEFINITIVO — RED AYUDA
CONSTRUCCIÓN COMPLETA EN ANTIGRAVITY

Quiero que actúes como un equipo senior completo de desarrollo de software dentro de Antigravity, compuesto por:

- Arquitecto de software.
- Desarrollador Flutter.
- Desarrollador Android.
- Desarrollador iOS.
- Desarrollador Java 21 / Spring Boot.
- Especialista PostgreSQL.
- Especialista Firebase Cloud Messaging.
- Especialista WebSocket.
- Especialista en geolocalización.
- Especialista en sistemas de emergencia.
- Especialista en seguridad.
- Especialista en privacidad.
- Desarrollador frontend web.
- QA / Testing.
- DevOps.
- Especialista GitHub Actions / CI-CD.

Tu misión es:

DISEÑAR
CONSTRUIR
EJECUTAR
PROBAR
CORREGIR
DOCUMENTAR
VERSIONAR
Y PREPARAR PARA DISTRIBUCIÓN

un sistema funcional llamado:

RED AYUDA

Lema:

“Una población organizada, una ciudad más segura”.

==================================================
1. CONTEXTO GENERAL
==================================================

RED AYUDA es una plataforma tecnológica de alerta y coordinación ciudadana ante emergencias.

Su primera implementación está orientada a Ayacucho, Perú, aunque debe diseñarse para escalar posteriormente a otras ciudades y regiones.

El sistema debe permitir que una persona pueda:

- generar una alerta SOS;
- compartir su ubicación;
- informar automáticamente a sus contactos de emergencia;
- alertar a usuarios cercanos;
- enviar un breve audio del entorno;
- facilitar acceso a servicios oficiales de emergencia;
- realizar seguimiento de ubicación durante la emergencia;
- mantener la emergencia registrada aunque el dispositivo pierda conexión;
- permitir que contactos sin la aplicación reciban información mediante SMS, WhatsApp u otros canales;
- permitir seguimiento desde una página web segura;
- disponer de un panel administrativo;
- funcionar posteriormente con activación por voz;
- incorporar posteriormente detección de accidentes;
- disponer de un sistema de ubicación redundante.

RED AYUDA NO sustituye a:

- Policía;
- Bomberos;
- SAMU;
- Serenazgo;
- hospitales;
- Defensa Civil;
- otras entidades oficiales.

RED AYUDA NO debe incentivar que los ciudadanos intervengan físicamente frente a delincuentes o situaciones peligrosas.

==================================================
2. OBJETIVO DE DESARROLLO
==================================================

Construir un sistema real y ejecutable compuesto por:

A. Aplicación móvil Flutter.
B. Backend REST.
C. Base de datos PostgreSQL.
D. Sistema de autenticación.
E. Sistema SOS.
F. Sistema de ubicación.
G. Sistema de notificaciones.
H. Sistema de audio.
I. Tracking en tiempo real.
J. Página web segura para contactos.
K. Panel administrativo.
L. GitHub.
M. GitHub Actions.
N. Build Android APK/AAB.
O. Validación/build iOS.
P. Documentación técnica.
Q. Pruebas automatizadas.
R. Docker.

NO quiero:

- pseudocódigo únicamente;
- pantallas sin lógica;
- funcionalidades simuladas presentadas como reales;
- archivos vacíos;
- TODOs como sustituto de funciones obligatorias;
- código que no compile.

==================================================
3. DEMOSTRACIÓN OBJETIVO
==================================================

El MVP debe poder demostrar el siguiente flujo:

TELÉFONO A:
usuario víctima.

TELÉFONO B:
usuario cercano o contacto.

LAPTOP:
panel administrativo.

Flujo esperado:

1. Usuario A inicia sesión.
2. Mantiene presionado SOS.
3. Se inicia cuenta regresiva.
4. La emergencia se confirma.
5. Se crea inmediatamente en backend.
6. Se obtiene ubicación.
7. Se notifica a contactos.
8. Se captura audio mínimo aproximado de 5 segundos.
9. Se sube el audio.
10. Usuario B recibe una alerta.
11. Contacto sin app recibe enlace mediante canal disponible.
12. El contacto abre mapa.
13. El contacto puede escuchar audio autorizado.
14. El panel administrativo muestra la emergencia.
15. La ubicación se actualiza.
16. El incidente puede finalizarse correctamente.
17. Todo queda registrado en historial.

==================================================
4. STACK TECNOLÓGICO
==================================================

Aplicación móvil:

Flutter
Dart

Backend:

Java 21
Spring Boot
Spring Security
Spring Data JPA
Bean Validation

Base de datos:

PostgreSQL

Considerar PostGIS si mejora búsquedas geográficas.

Autenticación:

JWT Access Token
JWT Refresh Token

Notificaciones:

Firebase Cloud Messaging

Tiempo real:

WebSocket

Mapas:

OpenStreetMap
o una librería Flutter compatible y mantenida.

Audio:

almacenamiento privado compatible con S3.

Documentación API:

OpenAPI
Swagger

Migraciones:

Flyway

Testing:

JUnit
Mockito
Testcontainers cuando sea útil
Flutter tests

Contenedores:

Docker
Docker Compose

Panel web:

usar una tecnología moderna y mantenible.

Seleccionar una opción coherente para todo el panel y documentarla.

==================================================
5. ESTRUCTURA GENERAL DEL REPOSITORIO
==================================================

Crear:

/backend
/mobile
/admin-web
/docs
/docker
/.github/workflows

Estructura backend sugerida:

controller
service
repository
entity
dto
mapper
security
config
exception
notification
location
storage
websocket
audit
integration

Estructura móvil:

presentation
domain
data
services
repositories
models
screens
widgets
core

No crear clases gigantes.

Separar responsabilidades.

==================================================
6. ROLES
==================================================

Roles iniciales:

CIUDADANO
CONTACTO_DE_CONFIANZA
ADMINISTRADOR
INSTITUCION

CIUDADANO:

- crear emergencias;
- configurar contactos;
- recibir alertas;
- consultar historial;
- configurar SOS.

CONTACTO_DE_CONFIANZA:

- recibir alertas;
- visualizar información autorizada;
- consultar ubicación;
- escuchar audio autorizado.

ADMINISTRADOR:

- gestionar usuarios;
- emergencias;
- directorio;
- reportes;
- estadísticas;
- auditoría.

INSTITUCION:

dejar arquitectura preparada para futuras funciones institucionales.

==================================================
7. REGISTRO
==================================================

Campos:

id
dni
nombres
apellidos
telefono
email
password
fecha_nacimiento
estado_verificacion
estado
fecha_creacion
fecha_actualizacion

Estado de verificación:

PENDIENTE
VERIFICADO
RECHAZADO

NO inventar integración oficial con RENIEC.

Crear una abstracción para proveedor de validación de identidad futura.

El DNI:

- no debe mostrarse públicamente;
- no debe enviarse a usuarios cercanos;
- debe tratarse como dato sensible.

==================================================
8. AUTENTICACIÓN
==================================================

Implementar:

registro
login
logout
refresh token
revocación
recuperación de contraseña
cambio de contraseña

Usar Spring Security.

Contraseñas:

BCrypt o Argon2.

Nunca almacenar contraseñas en texto plano.

Nunca almacenar PIN en texto plano.

==================================================
9. CONTACTOS DE EMERGENCIA
==================================================

Cada usuario podrá registrar inicialmente hasta 5 contactos.

Campos:

id
usuario_id
nombre
telefono
email
parentesco
prioridad
tiene_red_ayuda
usuario_red_ayuda_id
permite_ubicacion_precisa
permite_audio
activo

Los contactos NO están obligados a instalar RED AYUDA.

==================================================
10. NOTIFICACIÓN MULTICANAL
==================================================

Crear una arquitectura desacoplada:

NotificationService

Proveedores:

PushNotificationProvider
SmsProvider
WhatsAppProvider
EmailProvider

Primera prioridad:

Firebase Push.

SMS:

debe poder integrarse mediante proveedor real.

WhatsApp:

solo mediante API/proveedor autorizado.

Correo:

opcional.

Si no existen credenciales reales:

usar DEV provider.

El DEV provider debe registrar claramente:

SIMULADO
NO ENVIADO REALMENTE

Nunca decir:

“WhatsApp enviado”

si solamente se simuló.

Registrar:

id
emergencia_id
canal
destinatario
proveedor
estado
fecha
intentos
error

==================================================
11. BOTÓN SOS
==================================================

Pantalla principal con botón grande:

SOS

Texto:

MANTÉN PRESIONADO PARA PEDIR AYUDA

No activar con un toque.

Mantener presionado aproximadamente:

3 segundos.

Después:

vibración

y

cuenta regresiva.

Valor inicial:

10 segundos.

Configurable.

==================================================
12. CUENTA REGRESIVA
==================================================

Mostrar:

EMERGENCIA DETECTADA

La alerta se enviará en:

10
9
8
7...

Botón:

CANCELAR

Puede incluir vibración.

Sonido:

configurable.

==================================================
13. CANCELACIÓN SEGURA
==================================================

Implementar:

PIN NORMAL

PIN DE COACCIÓN

PIN normal:

cancela realmente.

PIN de coacción:

la interfaz aparenta cancelar.

Pero:

la emergencia continúa activa.

Guardar:

posible_coaccion = true

Registrar evento:

COERCION_PIN_USED

Los PIN se almacenan como hash.

Posteriormente permitir biometría mediante abstracción.

==================================================
14. REGLA CRÍTICA DEL SOS
==================================================

El SOS debe priorizar velocidad.

Orden obligatorio:

1. Termina cuenta regresiva.
2. Crear emergencia inmediatamente.
3. Intentar obtener ubicación.
4. Guardar primera ubicación disponible.
5. Iniciar notificaciones.
6. Capturar audio.
7. Subir audio.
8. Notificar usuarios cercanos.
9. Iniciar tracking.
10. Continuar actualizando información.

NUNCA hacer:

esperar audio
→ después crear emergencia.

==================================================
15. TIPOS DE EMERGENCIA
==================================================

Tipos:

ROBO
AGRESION
ACOSO
ACCIDENTE
EMERGENCIA_MEDICA
PERSONA_DESAPARECIDA
INCENDIO
OTRA
DESCONOCIDA

La activación automática puede empezar como:

DESCONOCIDA.

==================================================
16. UBICACIÓN REDUNDANTE
==================================================

RED AYUDA no dependerá únicamente del GPS.

Orden de prioridad:

1. Ubicación precisa.
2. Ubicación aproximada del sistema.
3. Última ubicación conocida.
4. Ubicación no disponible.

NO afirmar:

“triangulación real de antenas”

salvo que exista integración real con un operador.

Fuentes:

GPS
PRECISE_SYSTEM
NETWORK
APPROXIMATE
LAST_KNOWN
UNKNOWN

Guardar:

id
emergencia_id
latitud
longitud
precision_metros
fuente
fecha_hora
es_inicial
es_ultima_conocida

==================================================
17. UBICACIÓN SIN GPS
==================================================

Si no existe GPS:

NO bloquear la emergencia.

Usar:

ubicación aproximada

si está disponible.

Si no:

última ubicación conocida.

Si tampoco existe:

crear emergencia igual.

Marcar:

LOCATION_UNAVAILABLE

Seguir intentando obtener ubicación.

==================================================
18. MEJORA DE UBICACIÓN
==================================================

Ejemplo:

21:30:02
ubicación aproximada
precisión 850 m

21:30:15
ubicación precisa
precisión 20 m

Guardar ambas.

Marcar la más nueva.

Notificar al contacto:

UBICACIÓN MEJORADA

solo si la mejora es relevante.

==================================================
19. TRACKING
==================================================

Mientras emergencia esté activa:

obtener ubicación periódicamente.

Enviar backend.

Guardar historial.

Publicar WebSocket.

Actualizar mapa.

No enviar SMS por cada GPS.

Actualizar mapa frecuentemente.

Notificaciones externas:

solo cambios importantes.

==================================================
20. MOVIMIENTO
==================================================

Calcular desplazamiento.

Estados:

QUIETO
DESPLAZAMIENTO
MOVIMIENTO_RAPIDO

No afirmar:

“está en un vehículo”

sin evidencia suficiente.

==================================================
21. REGLAS DE NOTIFICACIÓN DE UBICACIÓN
==================================================

Notificar contactos cuando:

- llega primera ubicación;
- pasa de LAST_KNOWN a ubicación actual;
- pasa de aproximada a precisa;
- mejora significativamente la precisión;
- existe un desplazamiento relevante;
- dispositivo pierde conexión;
- batería baja;
- cambia estado;
- emergencia finaliza.

No enviar otra notificación por movimientos pequeños.

==================================================
22. AUDIO DE EMERGENCIA
==================================================

Después de activarse la emergencia:

capturar audio breve del entorno.

Duración mínima objetivo:

5 segundos.

Configurable:

5–10 segundos inicialmente.

Guardar:

id
emergencia_id
storage_key
duracion
fecha_hora
estado_subida

No retrasar SOS por audio.

==================================================
23. PRIVACIDAD DEL AUDIO
==================================================

Víctima:

sí.

Contacto autorizado:

sí.

Usuario cercano:

no.

Administrador:

solo cuando política/permisos lo autoricen.

Usar almacenamiento privado.

Generar:

signed URLs temporales.

Nunca publicar archivos de audio directamente.

==================================================
24. AVISO A CONTACTOS
==================================================

Mensaje conceptual:

ALERTA RED AYUDA

[NOMBRE] ha activado una emergencia.

Tipo:
[TIPO]

Hora:
[HORA]

Ubicación:
[ENLACE]

Audio:
[ENLACE CUANDO ESTÉ DISPONIBLE]

Estado:
ACTIVA

No esperar audio para mandar primera alerta.

==================================================
25. CONTACTOS SIN APLICACIÓN
==================================================

Crear una página web temporal.

Ruta conceptual:

/emergency/share/{token}

Token:

criptográficamente aleatorio
difícil de adivinar
expirable
revocable
asociado a permisos

El contacto puede abrirlo desde:

SMS
WhatsApp
correo

sin instalar RED AYUDA.

==================================================
26. PÁGINA DE SEGUIMIENTO
==================================================

Mostrar:

RED AYUDA

EMERGENCIA ACTIVA

Nombre
Tipo
Hora
Estado

Mapa
Ubicación
Precisión
Última actualización

Audio si está autorizado

Batería
Conectividad

Botones:

LLAMAR POLICÍA
LLAMAR SAMU
LLAMAR BOMBEROS

Otros servicios según configuración.

Actualizar en tiempo real.

==================================================
27. USUARIOS CERCANOS
==================================================

Recibirán únicamente:

tipo
distancia aproximada
zona
hora
estado

NO recibir:

DNI
teléfono
audio
ubicación exacta privada
datos sensibles

Ejemplo:

EMERGENCIA CERCA

Posible agresión.

Aproximadamente a 350 metros.

VER ZONA
LLAMAR A EMERGENCIAS

No poner:

“ve a enfrentarte”

o similares.

==================================================
28. RADIO DE ALERTA
==================================================

Radio progresivo configurable:

500 metros
1 km
2 km

El backend decide usuarios relevantes.

Evitar saturación.

==================================================
29. MODO ACCIDENTE
==================================================

Si tipo:

ACCIDENTE

y termina cuenta regresiva:

1. crear emergencia;
2. registrar ubicación;
3. avisar contactos;
4. capturar audio;
5. iniciar tracking;
6. facilitar llamada a servicios correspondientes.

==================================================
30. LLAMADA A EMERGENCIAS
==================================================

La app puede:

abrir marcador con número correcto

o usar funciones permitidas por el sistema.

NO afirmar que puede hacer llamadas automáticas si Android/iOS no lo permiten.

Si se requiere acción del usuario:

mostrarlo correctamente.

No intentar saltarse restricciones del sistema operativo.

==================================================
31. DIRECTORIO DE EMERGENCIAS
==================================================

Crear tabla:

directorio_emergencia

Campos:

id
nombre
tipo
telefono
region
provincia
distrito
prioridad
activo
fuente_verificacion
fecha_verificacion

Tipos:

POLICIA
SAMU
BOMBEROS
SERENAZGO
HOSPITAL
DEFENSA_CIVIL

NO hardcodear los números como única fuente.

El administrador debe poder actualizarlos.

==================================================
32. DETECCIÓN DE ACCIDENTES FUTURA
==================================================

Preparar arquitectura para:

acelerómetro
giroscopio
GPS
cambio de velocidad

Ejemplo conceptual:

impacto significativo
+
cambio brusco
+
inmovilidad

→ POSIBLE ACCIDENTE

→ vibración

→ “¿Estás bien?”

→ cuenta regresiva

→ si no responde
activar emergencia.

Debe marcarse como:

EXPERIMENTAL

hasta validación suficiente.

==================================================
33. ACTIVACIÓN POR VOZ
==================================================

Preparar función:

PROTECCIÓN POR VOZ

Usuario podrá configurar:

frase de activación.

Ejemplos:

RED AYUDA

o frase personalizada.

Flujo:

frase detectada
→ vibración
→ cuenta regresiva
→ emergencia.

==================================================
34. PRIVACIDAD DE VOZ
==================================================

Priorizar procesamiento local.

NO transmitir conversaciones permanentemente.

NO guardar conversaciones normales.

Solo capturar audio de emergencia después de activación.

==================================================
35. RESTRICCIONES DE BACKGROUND
==================================================

Respetar:

Android
iOS

Revisar restricciones actuales de:

micrófono
ubicación
background services
foreground services
notificaciones
sensores
llamadas
voz

Si una función no puede ejecutarse:

documentar.

Implementar alternativa válida.

No fingir soporte.

==================================================
36. APAGADO DEL TELÉFONO
==================================================

NO intentar impedir físicamente apagar el teléfono.

NO saltarse restricciones.

Estrategia:

crear SOS rápido
enviar GPS rápido
notificar rápido
guardar datos en servidor

Si pierde conexión:

mantener emergencia activa.

==================================================
37. DISPOSITIVO OFFLINE
==================================================

Si dispositivo deja de responder:

crear evento:

DEVICE_OFFLINE

Mostrar:

última conexión
última ubicación
precisión
batería

Informar a contactos según reglas.

==================================================
38. FUNCIONAMIENTO OFFLINE
==================================================

Sin Internet:

guardar localmente:

SOS pendiente
ubicación
audio
eventos
actualizaciones

Cuando vuelve Internet:

sincronizar.

Usar:

UUID
idempotency keys

Evitar duplicados.

==================================================
39. BATERÍA
==================================================

Registrar batería cuando sea posible.

Si baja de:

15 %

durante emergencia:

crear evento:

BATTERY_LOW

Notificar una vez de forma controlada.

==================================================
40. ESTADOS DE EMERGENCIA
==================================================

Crear máquina de estados:

CREADA
ACTIVA
AYUDA_SOLICITADA
EN_ATENCION
RESUELTA
CANCELADA
FALSA_ALARMA

Evitar transiciones inválidas.

==================================================
41. EVENTOS DE EMERGENCIA
==================================================

Crear timeline inmutable.

Eventos posibles:

SOS_TRIGGERED
COUNTDOWN_STARTED
EMERGENCY_CREATED
LOCATION_RECEIVED
LOCATION_IMPROVED
LOCATION_UNAVAILABLE
CONTACT_NOTIFIED
NEARBY_USERS_NOTIFIED
AUDIO_CAPTURED
AUDIO_UPLOADED
SERVICE_CALL_OPENED
BATTERY_LOW
DEVICE_OFFLINE
COERCION_PIN_USED
CANCEL_ATTEMPT_FAILED
STATUS_CHANGED
EMERGENCY_FINISHED

Guardar:

id
emergencia_id
tipo
timestamp
metadata

==================================================
42. HISTORIAL
==================================================

Usuario puede consultar:

fecha
hora
tipo
zona
estado
duración

Detalle:

mapa
timeline
ubicaciones
contactos notificados
estado final

Audio:

solo según permisos.

==================================================
43. FALSAS ALARMAS
==================================================

No eliminar.

Marcar:

FALSA_ALARMA

Registrar:

quién
cuándo
motivo

==================================================
44. ABUSO
==================================================

Estados:

NORMAL
ADVERTIDO
RESTRINGIDO
SUSPENDIDO

Reglas auditables.

No bloquear injustificadamente emergencias reales.

==================================================
45. PANEL ADMINISTRATIVO
==================================================

Dashboard:

usuarios registrados
usuarios verificados
emergencias activas
emergencias del día
emergencias del mes
falsas alarmas
notificaciones fallidas

Secciones:

Dashboard
Usuarios
Emergencias
Mapa
Directorio
Reportes
Estadísticas
Configuración
Auditoría

==================================================
46. MAPA ADMINISTRATIVO
==================================================

Mostrar emergencias activas.

Filtros:

tipo
estado
fecha
distrito

Aplicar permisos.

No exponer información innecesaria.

==================================================
47. ESTADÍSTICAS
==================================================

Crear:

emergencias por tipo
por fecha
por hora
por distrito
duración
falsas alarmas
canal de notificación
tasa de entrega

Usar información agregada/anonimizada.

==================================================
48. BASE DE DATOS
==================================================

Diseñar como mínimo:

usuarios
roles
usuario_roles
dispositivos
refresh_tokens

contactos_confianza
configuracion_emergencia

tipos_emergencia
emergencias
emergencia_ubicaciones
emergencia_audios
emergencia_eventos
emergencia_notificaciones
usuarios_cercanos_notificados

directorio_emergencia
emergency_share_tokens

reportes
sanciones
auditoria

Agregar tablas adicionales si la normalización lo requiere.

Crear:

PK
FK
índices
constraints
migraciones

==================================================
49. SEGURIDAD
==================================================

Aplicar:

HTTPS en producción
JWT
refresh tokens revocables
RBAC
rate limiting
validación DTO
CORS restrictivo
auditoría
variables de entorno
hash de contraseñas
hash de PIN
tokens aleatorios seguros
signed URLs
expiración
protección IDOR
validación de archivos
logs seguros

No subir secretos.

==================================================
50. PRIVACIDAD
==================================================

Aplicar minimización de datos.

Ubicación exacta:

solo contactos autorizados.

Audio:

solo contactos autorizados.

No exponer:

DNI
teléfono privado
historial
contactos

No permitir enumerar emergencias públicas.

Definir política configurable de retención para:

audio
ubicaciones
logs
incidentes

==================================================
51. PANTALLAS MÓVILES
==================================================

Crear:

Splash
Onboarding
Registro
Login
Recuperación
Verificación
Inicio
SOS
Cuenta regresiva
Tipo de emergencia
Emergencia activa
Mapa
Alertas cercanas
Detalle de alerta
Contactos
Agregar contacto
Editar contacto
Directorio
Historial
Detalle de emergencia
Perfil
Configuración
Configuración SOS
Configuración voz
Privacidad
Permisos
Estado de protección

==================================================
52. HOME
==================================================

Mostrar:

RED AYUDA

Estado de protección

Botón grande:

SOS

Texto:

MANTÉN PRESIONADO PARA PEDIR AYUDA

Navegación:

Inicio
Mapa
Contactos
Historial
Perfil

==================================================
53. ESTADO DE PROTECCIÓN
==================================================

Ejemplo:

PROTECCIÓN COMPLETA

Ubicación: disponible
Contactos: configurados
Notificaciones: activas
Micrófono SOS: permitido
Voz: activa

Si algo falta:

PROTECCIÓN LIMITADA

Ejemplo:

Ubicación precisa desactivada.

RED AYUDA intentará usar una ubicación aproximada o última ubicación conocida.

No bloquear la app completamente.

==================================================
54. EMERGENCIA ACTIVA
==================================================

Mostrar:

EMERGENCIA ACTIVA

tipo
tiempo
ubicación
precisión
audio
contactos avisados
usuarios cercanos
servicio recomendado

Botones:

VER MAPA
LLAMAR SERVICIO
FINALIZAR

Finalizar requiere seguridad.

==================================================
55. GITHUB
==================================================

Todo el proyecto debe almacenarse en GitHub.

GitHub será fuente oficial.

Crear:

.gitignore
README.md
.env.example

NO subir:

.env
tokens
API keys
keystores reales
certificados Apple
service accounts
claves privadas
contraseñas

==================================================
56. RAMAS GIT
==================================================

Usar:

main
develop

Opcional:

feature/sos
feature/audio
feature/location
feature/voice

main:

estable.

develop:

integración.

==================================================
57. GITHUB ACTIONS
==================================================

Crear:

.github/workflows/backend-ci.yml
.github/workflows/mobile-android.yml
.github/workflows/mobile-ios.yml
.github/workflows/admin-web-ci.yml

Opcional:

release.yml

==================================================
58. BACKEND CI
==================================================

backend-ci.yml:

trigger:

push main
push develop
pull_request
workflow_dispatch

Pasos:

checkout
Java 21
cache
compile
tests
package
upload JAR artifact

Fallará si:

tests fallan
compilación falla

No usar:

|| true

para ocultar errores.

==================================================
59. ANDROID CI
==================================================

Crear:

mobile-android.yml

Pasos:

checkout
configurar Java
configurar Flutter
flutter pub get
flutter analyze
flutter test
flutter build apk
flutter build appbundle

Generar:

RED-Ayuda.apk
RED-Ayuda.aab

Subir como:

GitHub Actions Artifacts.

==================================================
60. APK DEBUG
==================================================

Primero permitir:

APK debug

sin firma compleja.

Después:

release APK
release AAB

==================================================
61. FIRMA ANDROID
==================================================

Usar GitHub Secrets.

Ejemplo:

ANDROID_KEYSTORE_BASE64
ANDROID_KEYSTORE_PASSWORD
ANDROID_KEY_ALIAS
ANDROID_KEY_PASSWORD

Nunca subir keystore real al repositorio.

==================================================
62. DESCARGA DE APK
==================================================

Después de build:

GitHub
→ Actions
→ Android Build
→ Artifacts
→ descargar APK

README debe explicar el proceso.

==================================================
63. RELEASES
==================================================

Cuando exista tag:

v0.1.0
v0.2.0
v1.0.0

release.yml podrá:

compilar
probar
generar APK
generar AAB
adjuntar archivos a GitHub Release

Ejemplo:

RED-Ayuda-v0.1.0.apk

==================================================
64. VERSIONADO
==================================================

Usar Semantic Versioning.

Mientras desarrollo:

0.x.x

Primera estable:

1.0.0

Configurar correctamente versión Flutter.

==================================================
65. IOS CI
==================================================

Crear:

mobile-ios.yml

Runner:

macOS

Pasos:

checkout
Flutter
flutter pub get
flutter analyze
flutter test
CocoaPods cuando corresponda
build iOS

Primera fase:

flutter build ios --no-codesign

Objetivo:

comprobar que compila.

==================================================
66. IOS SIN APPLE DEVELOPER
==================================================

Mientras no exista cuenta Apple Developer:

hacer:

build iOS unsigned
tests
validation

Mostrar claramente:

IOS BUILD:
COMPILED
UNSIGNED

No decir:

IPA listo

si no está firmado.

==================================================
67. IOS FIRMADO
==================================================

Cuando existan credenciales:

preparar para:

certificado
provisioning profile
Bundle ID
Team ID
App Store Connect

Generar:

RED-Ayuda.ipa

==================================================
68. GITHUB SECRETS IOS
==================================================

Ejemplos:

APPLE_TEAM_ID
APPLE_BUNDLE_ID
APPLE_CERTIFICATE_BASE64
APPLE_CERTIFICATE_PASSWORD
APPLE_PROVISIONING_PROFILE_BASE64

Para App Store Connect:

APP_STORE_CONNECT_KEY_ID
APP_STORE_CONNECT_ISSUER_ID
APP_STORE_CONNECT_PRIVATE_KEY

Nunca subir estos archivos al repo.

==================================================
69. TESTFLIGHT
==================================================

Preparar arquitectura futura:

GitHub
→ Actions
→ iOS build
→ signing
→ IPA
→ App Store Connect
→ TestFlight

No subir automáticamente hasta configurar credenciales.

==================================================
70. GOOGLE PLAY
==================================================

Preparar:

GitHub
→ Actions
→ AAB
→ Google Play Console

Futuro:

Internal Testing
Closed Testing
Production

No publicar automáticamente al principio.

==================================================
71. ARTEFACTOS
==================================================

Generar:

BACKEND:

red-ayuda-backend.jar

ANDROID:

RED-Ayuda.apk
RED-Ayuda.aab

IOS:

unsigned build

y después:

RED-Ayuda.ipa

ADMIN:

build web production

==================================================
72. WORKFLOW MANUAL
==================================================

Los builds deben soportar:

workflow_dispatch

para poder hacer:

Run workflow

desde GitHub.

==================================================
73. BADGES
==================================================

README:

Backend CI
Android Build
iOS Build
Admin Web

Mostrar estado real.

==================================================
74. COMPATIBILIDAD ANDROID / IOS
==================================================

Desde el principio mantener compatibilidad multiplataforma.

Crear servicios abstractos:

EmergencyLocationService
EmergencyAudioService
EmergencyCallService
VoiceTriggerService
SensorService
NotificationService

Implementar por plataforma cuando sea necesario.

==================================================
75. MATRIZ DE SOPORTE
==================================================

Crear:

/docs/platform-support.md

Tabla:

FUNCIONALIDAD | ANDROID | IOS | LIMITACIÓN

Ejemplo:

SOS manual | Sí | Sí | -
GPS | Sí | Sí | permisos
Push | Sí | Sí | FCM/APNs
Audio SOS | según permisos | según permisos | background
Voz | evaluar | evaluar | restricciones OS
SMS directo | restringido | restringido | plataforma
Llamada automática | restringido | restringido | plataforma

==================================================
76. GITHUB COMO ENTREGA
==================================================

El sistema debe poder:

clonarse
configurarse
compilarse
probarse
ejecutarse

Desde README:

git clone
cd
docker compose up

y los comandos correspondientes.

==================================================
77. VARIABLES DE ENTORNO
==================================================

Crear:

.env.example

Variables para:

PostgreSQL
JWT
Firebase
S3
SMS
WhatsApp
email
backend
frontend

No poner secretos reales.

==================================================
78. DATOS DEV
==================================================

Crear seeds DEV:

usuario víctima
usuario cercano
contacto
admin
tipos de emergencia
directorio ficticio

Marcar claramente:

DEV
TEST
NO OFICIAL

==================================================
79. PRUEBAS
==================================================

Crear pruebas:

unitarias
integración
repositorios
seguridad
API
Flutter

Probar:

registro
login
refresh
permisos
SOS
SOS duplicado
ubicación
ubicación mejorada
audio
notificación
PIN normal
PIN coacción
share token
expiración
revocación
WebSocket
offline
finalización

==================================================
80. DOCUMENTACIÓN
==================================================

Crear:

README.md

/docs/MASTER_PLAN.md
/docs/architecture.md
/docs/database.md
/docs/api.md
/docs/security.md
/docs/emergency-flow.md
/docs/mobile.md
/docs/platform-support.md
/docs/deployment.md
/docs/limitations.md

README debe permitir a otra persona ejecutar todo.

==================================================
81. CRITERIO DE FUNCIONALIDAD TERMINADA
==================================================

Una función solo está terminada si:

compila
ejecuta
persiste datos
maneja errores
tiene validaciones
respeta permisos
tiene pruebas razonables
está documentada

==================================================
82. PROHIBICIONES
==================================================

NO:

inventar APIs
inventar RENIEC
inventar triangulación del operador
fingir WhatsApp real
fingir SMS real
fingir llamada automática
fingir build iOS firmado
evadir permisos Android/iOS
grabar conversaciones continuamente
publicar audios
exponer ubicación sensible
guardar contraseñas en texto plano
guardar PIN en texto plano
hardcodear secretos
ocultar errores
borrar incidentes para ocultar falsa alarma
usar TODOs como sustituto de implementación

==================================================
83. PLAN DE IMPLEMENTACIÓN
==================================================

FASE 0
Análisis general.

FASE 1
Repositorio Git + estructura + Docker + PostgreSQL.

FASE 2
GitHub Actions inicial.

FASE 3
Backend base.

FASE 4
Autenticación y usuarios.

FASE 5
Contactos de emergencia.

FASE 6
Configuración SOS.

FASE 7
Emergencias y máquina de estados.

FASE 8
Aplicación Flutter base.

FASE 9
SOS manual.

FASE 10
Ubicación redundante.

FASE 11
Notificaciones push.

FASE 12
Audio.

FASE 13
Tracking y WebSocket.

FASE 14
Enlace web para contactos.

FASE 15
SMS provider abstraction.

FASE 16
WhatsApp provider abstraction.

FASE 17
Directorio.

FASE 18
Panel administrativo.

FASE 19
PIN de coacción.

FASE 20
Offline.

FASE 21
Build Android completo.

FASE 22
Build iOS validation.

FASE 23
Modo voz.

FASE 24
Modo accidente experimental.

FASE 25
Pruebas integrales.

FASE 26
Release GitHub.

==================================================
84. FORMA DE TRABAJO EN ANTIGRAVITY
==================================================

Antes de modificar:

inspecciona el workspace.

Si ya existen archivos:

no sobrescribir trabajo válido.

Crear primero:

/docs/MASTER_PLAN.md

Después:

implementar una fase a la vez.

En cada fase:

1. crear archivos;
2. modificar archivos;
3. instalar dependencias;
4. compilar;
5. ejecutar tests;
6. iniciar servicios cuando sea posible;
7. revisar logs;
8. corregir;
9. volver a ejecutar;
10. documentar.

NO avanzar con errores conocidos.

==================================================
85. COMPORTAMIENTO AUTÓNOMO
==================================================

No me preguntes por decisiones menores.

Toma decisiones técnicas razonables.

Documenta las importantes.

Solo detente si:

- falta una credencial externa obligatoria;
- existe una limitación real del sistema operativo;
- una decisión puede afectar significativamente arquitectura o seguridad.

Cuando falten credenciales:

implementar adapter/mock DEV claramente identificado.

Continuar con el resto.

==================================================
86. PRIMERA TAREA OBLIGATORIA
==================================================

NO empieces creando cientos de archivos.

Primero:

A. analiza toda esta especificación;
B. define arquitectura;
C. define estructura del repositorio;
D. diseña modelo entidad-relación;
E. diseña máquina de estados;
F. define endpoints REST;
G. define eventos WebSocket;
H. define estrategia de notificaciones;
I. define estrategia de ubicación;
J. define almacenamiento de audio;
K. define seguridad;
L. analiza diferencias Android/iOS;
M. separa MVP de funciones avanzadas;
N. crea /docs/MASTER_PLAN.md;
O. crea roadmap por fases.

Después de completar el plan:

COMIENZA AUTOMÁTICAMENTE FASE 1.

==================================================
87. OBJETIVO FINAL
==================================================

El objetivo final no es generar mucho código.

El objetivo es entregar RED AYUDA funcionando.

Debe ser posible:

1. clonar el repositorio;
2. iniciar backend;
3. iniciar PostgreSQL;
4. ejecutar app Flutter;
5. registrar usuario;
6. registrar contactos;
7. activar SOS;
8. registrar ubicación;
9. grabar audio;
10. notificar;
11. visualizar emergencia;
12. seguir ubicación;
13. visualizar panel administrativo;
14. generar APK desde GitHub Actions;
15. descargar APK desde GitHub;
16. validar build iOS;
17. generar IPA cuando exista firma Apple;
18. crear releases versionados.

No consideres el proyecto finalizado hasta que estos componentes estén documentados y el MVP principal pueda ejecutarse.