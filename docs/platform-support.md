# Matriz de Soporte por Plataforma — RED AYUDA

| Funcionalidad | Android | iOS | Limitación / Regla de Plataforma |
|---|---|---|---|
| **Botón SOS Manual (3s Hold)** | Sí | Sí | Totalmente soportado en primer plano con retroalimentación háptica. |
| **Cuenta Regresiva (10s)** | Sí | Sí | Configurable en ambas plataformas. Cancelable con PIN. |
| **PIN de Coacción Silencioso** | Sí | Sí | Aparenta cancelación en la UI pero mantiene alerta activa en el servidor. |
| **GPS y Ubicación Precisa** | Sí | Sí | Requiere permiso en uso y siempre activo durante el incidente. |
| **Ubicación Redundante (Red/Última)** | Sí | Sí | Fallback inmediato si no hay señal satelital visible. |
| **Grabación de Audio SOS (5s)** | Sí | Sí | Se ejecuta inmediatamente tras confirmarse el SOS en primer plano. |
| **Tracking en Segundo Plano** | Sí | Sí | Android usa Foreground Service con notificación fija. iOS usa Background Location indicator. |
| **Notificaciones Push** | Sí | Sí | Soportado mediante Firebase Cloud Messaging (FCM) y APNs. |
| **Acceso Web para Contactos** | Sí | Sí | Funciona en cualquier navegador móvil o desktop mediante `/emergency/share/{token}`. |
| **Llamada de Auxilio Oficial** | Sí | Sí | Abre el marcador telefónico del sistema (`105`, `106`, `116`) para confirmación del usuario, respetando políticas de seguridad de Google y Apple. |
| **Activación por Voz** | Experimental | Experimental | Restringido por el SO en segundo plano; modo escucha activa en foreground. |
| **Detección de Accidentes** | Experimental | Experimental | Sensores de acelerometría y CoreMotion; requiere confirmación previa de 10s. |
