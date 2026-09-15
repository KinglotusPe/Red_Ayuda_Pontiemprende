# RED AYUDA
> *“Una población organizada, una ciudad más segura”*

![Backend CI](https://github.com/KinglotusPe/Red_Ayuda_Pontiemprende/actions/workflows/backend-ci.yml/badge.svg)
![Android Build](https://github.com/KinglotusPe/Red_Ayuda_Pontiemprende/actions/workflows/mobile-android.yml/badge.svg)
![iOS Build](https://github.com/KinglotusPe/Red_Ayuda_Pontiemprende/actions/workflows/mobile-ios.yml/badge.svg)
![Admin Web](https://github.com/KinglotusPe/Red_Ayuda_Pontiemprende/actions/workflows/admin-web-ci.yml/badge.svg)

**RED AYUDA** es una plataforma tecnológica de alerta temprana y coordinación ciudadana ante emergencias ciudadanas, médicas y de siniestros. Su primera implementación operativa está orientada a **Ayacucho, Perú** (Plaza Mayor de Huamanga, Comisarías, Hospital Regional, SAMU y Serenazgo), con una arquitectura modular lista para escalar a nivel nacional.

---

## 📱 ¿Cómo descargar el APK de Android y el build de iOS?

Los binarios móviles se compilan automáticamente en la nube mediante **GitHub Actions** cada vez que se actualiza el código.

### Para descargar el APK instalable en tu teléfono:
1. Entra al repositorio en GitHub: [https://github.com/KinglotusPe/Red_Ayuda_Pontiemprende](https://github.com/KinglotusPe/Red_Ayuda_Pontiemprende).
2. Haz clic en la pestaña **Actions** en la parte superior.
3. Selecciona el workflow **Mobile Android - Build APK & AAB**.
4. Haz clic en la ejecución más reciente (la primera de la lista).
5. Desplázate hacia abajo hasta la sección **Artifacts** y descarga:
   - **`RED-Ayuda-Android-APK`**: Contiene el archivo `RED-Ayuda.apk` listo para instalar en cualquier teléfono Android.
   - **`RED-Ayuda-Android-AAB`**: Paquete firmado para publicación en Google Play Store.

### Para descargar el build de iOS:
1. En la pestaña **Actions**, entra al workflow **Mobile iOS - Build & Validation**.
2. En la sección **Artifacts**, descarga **`RED-Ayuda-iOS-Package`** (Paquete Runner sin firma para pruebas técnicas en macOS o firma con certificados Apple Developer).

---

## 🚀 Inicio Rápido con Docker Compose

Puedes levantar todo el ecosistema (PostgreSQL 16, MinIO S3, Backend Java 21 y Panel Web) con un solo comando:

```bash
# 1. Clonar el repositorio
git clone https://github.com/KinglotusPe/Red_Ayuda_Pontiemprende.git
cd Red_Ayuda_Pontiemprende

# 2. Iniciar todos los contenedores
docker compose -f docker/docker-compose.yml up -d --build
```

### URLs del Entorno:
| Servicio | URL | Credenciales por Defecto |
|---|---|---|
| **Panel Web / Portal de Contactos** | [http://localhost:3000](http://localhost:3000) | Acceso directo / enlaces de seguimiento |
| **Backend REST API** | [http://localhost:8080/api/v1](http://localhost:8080/api/v1) | - |
| **Documentación Swagger / OpenAPI** | [http://localhost:8080/swagger-ui.html](http://localhost:8080/swagger-ui.html) | Explorador interactivo de endpoints |
| **Consola MinIO (Audios Privados)** | [http://localhost:9001](http://localhost:9001) | User: `minio_access_key` / Pass: `minio_secret_password` |
| **PostgreSQL 16** | `localhost:5432` | DB: `red_ayuda_db` / User: `redayuda_user` |

---

## 🔑 Credenciales Seed para Pruebas (Entorno DEV)

| Rol | Correo Electrónico | Contraseña | PIN Normal | PIN Coacción |
|---|---|---|---|---|
| **Administrador** | `admin@redayuda.pe` | `Admin123456!` | `1234` | `9999` |
| **Víctima / Ciudadano** | `victima@redayuda.pe` | `Admin123456!` | `1234` | `9999` |
| **Contacto de Confianza** | `contacto@redayuda.pe` | `Admin123456!` | `1234` | `9999` |
| **Vecino Cercano** | `vecino@redayuda.pe` | `Admin123456!` | `1234` | `9999` |

---

## 🛡️ Características Clave del Sistema

1. **Botón SOS con Bloqueo de Pulsación Accidental**:
   - Requiere mantener presionado durante 3 segundos con pulso háptico visual y cuenta regresiva de 10 segundos antes de emitir la alerta.
2. **Mecanismo de PIN de Coacción**:
   - Si la persona es forzada a cancelar bajo amenaza física, ingresa su PIN de coacción (`9999`). La aplicación simula ante el agresor una cancelación normal, pero el servidor mantiene la alerta activa en segundo plano con la marca `posible_coaccion = true` y avisa silenciosamente a sus contactos.
3. **Ubicación Satelital Redundante**:
   - Prioriza GPS de alta precisión; si la señal satelital tarda en fijarse, utiliza ubicación aproximada de red celular/Wi-Fi o la última conocida. El SOS nunca se detiene por falta de coordenadas.
4. **Grabación de Audio Ambiental Inmediata (5-10s)**:
   - Se captura automáticamente tras confirmarse la cuenta regresiva y se guarda en almacenamiento privado accesible solo mediante URLs firmadas temporales de 15 minutos.
5. **Seguimiento Seguro para Contactos sin Aplicación**:
   - Enlace web criptográfico temporal (`/emergency/share/{token}`) que permite a los familiares ver en tiempo real el mapa satelital, batería, audio autorizado y realizar llamadas directas a las autoridades oficiales sin instalar la app.
6. **Directorio Oficial de Emergencia (Ayacucho)**:
   - Acceso con un toque a la Policía Nacional del Perú (105), SAMU (106), Bomberos (116) y Serenazgo de Huamanga (066-312444).

---

## 📚 Documentación Técnica Detallada

- [Plan Maestro de Arquitectura y Construcción](file:///docs/MASTER_PLAN.md)
- [Arquitectura de Software y Diagramas](file:///docs/architecture.md)
- [Esquema de Base de Datos y Diccionario de Datos](file:///docs/database.md)
- [Especificación de la API REST y WebSockets](file:///docs/api.md)
- [Protocolos de Seguridad y PIN de Coacción](file:///docs/security.md)
- [Flujo de Demostración del SOS](file:///docs/emergency-flow.md)
- [Arquitectura de la App Móvil Flutter](file:///docs/mobile.md)
- [Matriz de Soporte Android vs iOS](file:///docs/platform-support.md)
- [Guía de Despliegue e Infraestructura](file:///docs/deployment.md)
- [Límites y Consideraciones de Plataforma](file:///docs/limitations.md)
