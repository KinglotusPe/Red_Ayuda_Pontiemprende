# RED AYUDA
> *“Una población organizada, una ciudad más segura”*

![Release](https://img.shields.io/github/v/release/KinglotusPe/Red_Ayuda_Pontiemprende?style=flat-square&color=success&label=Release%20Oficial)
![Android CI](https://github.com/KinglotusPe/Red_Ayuda_Pontiemprende/actions/workflows/mobile-android.yml/badge.svg)
![iOS CI](https://github.com/KinglotusPe/Red_Ayuda_Pontiemprende/actions/workflows/mobile-ios.yml/badge.svg)
![Backend CI](https://github.com/KinglotusPe/Red_Ayuda_Pontiemprende/actions/workflows/backend-ci.yml/badge.svg)
![Admin Web](https://github.com/KinglotusPe/Red_Ayuda_Pontiemprende/actions/workflows/admin-web-ci.yml/badge.svg)

**RED AYUDA** es una plataforma tecnológica de alerta temprana y coordinación ciudadana ante emergencias personales, médicas y de seguridad. Su primera implementación operativa está configurada para **Ayacucho, Perú** (Plaza Mayor de Huamanga, Comisarías PNP, Hospital Regional, SAMU y Serenazgo), con una arquitectura modular lista para escalar a nivel nacional.

---

## 📥 Enlaces Directos de Descarga Oficial

Los instaladores han sido compilados y firmados automáticamente por los pipelines de GitHub Actions. Puedes descargarlos directamente a continuación o desde la sección oficial de [Releases de GitHub](https://github.com/KinglotusPe/Red_Ayuda_Pontiemprende/releases/tag/v1.0.1):

| Plataforma / Componente | Archivo Descargable | Tamaño | Enlace de Descarga Directa |
| :--- | :--- | :--- | :--- |
| **🤖 Android (Instalación Directa)** | `RED-Ayuda-v1.0.1.apk` | 22.4 MB | [📲 **Descargar APK para Android**](https://github.com/KinglotusPe/Red_Ayuda_Pontiemprende/releases/download/v1.0.1/RED-Ayuda-v1.0.1.apk) |
| **🤖 Android (Google Play Store Bundle)** | `RED-Ayuda-v1.0.1.aab` | 22.5 MB | [📦 **Descargar AAB (Play Store)**](https://github.com/KinglotusPe/Red_Ayuda_Pontiemprende/releases/download/v1.0.1/RED-Ayuda-v1.0.1.aab) |
| **🍎 iOS (Instalación Sideload / AltStore / TrollStore)** | `RED-Ayuda-iOS-v1.0.1.ipa` | 23.0 MB | [🍏 **Descargar IPA para iOS**](https://github.com/KinglotusPe/Red_Ayuda_Pontiemprende/releases/download/v1.0.1/RED-Ayuda-iOS-v1.0.1.ipa) |
| **🍎 iOS (Runner Bundle ZIP)** | `RED-Ayuda-iOS-Runner-v1.0.1.zip` | 23.0 MB | [🗜️ **Descargar Runner ZIP (iOS)**](https://github.com/KinglotusPe/Red_Ayuda_Pontiemprende/releases/download/v1.0.1/RED-Ayuda-iOS-Runner-v1.0.1.zip) |
| **☕ Backend Servidor (Java 21 / Spring Boot)** | `red-ayuda-backend-v1.0.1.jar` | 72.1 MB | [⚙️ **Descargar JAR del Backend**](https://github.com/KinglotusPe/Red_Ayuda_Pontiemprende/releases/download/v1.0.1/red-ayuda-backend-v1.0.1.jar) |

> 💡 **Instrucciones para instalar en Android:**
> 1. Descarga el archivo [`RED-Ayuda-v1.0.1.apk`](https://github.com/KinglotusPe/Red_Ayuda_Pontiemprende/releases/download/v1.0.1/RED-Ayuda-v1.0.1.apk) en tu teléfono.
> 2. Ábrelo y selecciona *Instalar*. Si tu dispositivo lo solicita, habilita la opción *"Permitir instalar aplicaciones de orígenes desconocidos"*.
> 
> 💡 **Instrucciones para instalar en iOS:**
> - El archivo [`RED-Ayuda-iOS-v1.0.1.ipa`](https://github.com/KinglotusPe/Red_Ayuda_Pontiemprende/releases/download/v1.0.1/RED-Ayuda-iOS-v1.0.1.ipa) se puede instalar directamente mediante herramientas de sideloading como **AltStore**, **Sideloadly**, **TrollStore** o mediante Xcode Organizer.

### 📦 Descarga alternativa desde GitHub Actions Artifacts:
También puedes obtener las compilaciones generadas en cada commit desde [GitHub Actions Runs](https://github.com/KinglotusPe/Red_Ayuda_Pontiemprende/actions):
- Artefactos de Android: `RED-Ayuda-Android-APK` y `RED-Ayuda-Android-AAB`.
- Artefactos de iOS: `RED-Ayuda-iOS-Package`.

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

