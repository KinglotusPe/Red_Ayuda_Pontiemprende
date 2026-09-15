# Despliegue e Infraestructura — RED AYUDA

## 1. Despliegue Local con Docker Compose
La forma más rápida de ejecutar todo el ecosistema (Base de datos PostgreSQL, MinIO, Backend Spring Boot y Panel Web) es:

```bash
# 1. Clonar el repositorio
git clone https://github.com/KinglotusPe/Red_Ayuda_Pontiemprende.git
cd Red_Ayuda_Pontiemprende

# 2. Iniciar contenedores
docker compose -f docker/docker-compose.yml up -d --build
```

### Puertos Expuestos:
- **Panel Web / Portal de Seguimiento**: `http://localhost:3000`
- **Backend API REST**: `http://localhost:8080/api/v1`
- **Documentación Swagger / OpenAPI**: `http://localhost:8080/swagger-ui.html`
- **MinIO Console**: `http://localhost:9001` (User: `minio_access_key`, Password: `minio_secret_password`)
- **PostgreSQL 16**: `localhost:5432`

---

## 2. Generación y Descarga de Artefactos Móviles (APK e iOS)

### Descarga del APK de Android:
1. Accede al repositorio en GitHub: `https://github.com/KinglotusPe/Red_Ayuda_Pontiemprende`
2. Ve a la pestaña **Actions**.
3. Selecciona el workflow **Mobile Android - Build APK & AAB**.
4. Haz clic en la última ejecución exitosa.
5. En la sección **Artifacts**, descarga:
   - `RED-Ayuda-Android-APK` (Contiene `RED-Ayuda.apk` instalable directamente en tu teléfono Android).
   - `RED-Ayuda-Android-AAB` (Paquete para publicación en Google Play Console).

### Validación y Build de iOS:
1. En la pestaña **Actions**, selecciona **Mobile iOS - Build & Validation**.
2. En la sección **Artifacts**, descarga `RED-Ayuda-iOS-Package` (Bundle compilado sin firma para validación técnica en macOS o firma con certificados Apple Developer).
