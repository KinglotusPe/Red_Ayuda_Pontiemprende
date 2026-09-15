# Arquitectura de la Aplicación Móvil — RED AYUDA

## 1. Tecnologías y Principios
- **Framework**: Flutter 3.24+ / Dart 3.4+
- **Arquitectura**: Clean Architecture orientada a características (`core`, `models`, `services`, `presentation`).
- **Gestión de Estado**: `Provider` (`EmergencyState`) para centralización de telemetría, cuenta regresiva y nivel de protección.
- **Seguridad**: Diálogo numérico de PIN con distinción entre PIN de cancelación normal y PIN de coacción simulada.

## 2. Pantallas y Componentes
1. **SplashScreen**: Inicialización de credenciales locales y enrutamiento inteligente.
2. **Login / Register**: Autenticación segura con JWT y validación estricta de DNI peruano.
3. **HomeScreen**:
   - `ProtectionStatusCard`: Monitor en tiempo real de permisos y nivel de protección.
   - Selector rápido de emergencia (Robo, Agresión, Acoso, Accidente, Médica).
   - `SosButton`: Botón principal con animación de pulso y requisito de mantener presionado 3 segundos.
   - Marcador rápido de auxilio oficial (105, 106, 116).
4. **CountdownScreen**: Cuenta regresiva de 10 segundos con cancelación segura protegida por PIN.
5. **ActiveEmergencyScreen**: Telemetría en vivo, duración, audio capturado, contactos notificados y finalización segura con PIN.
6. **ContactsScreen / AddContactScreen**: Registro de hasta 5 contactos de auxilio con permisos granulares de audio y ubicación.
7. **DirectoryScreen**: Números oficiales de la región Ayacucho (Comisarías, SAMU, Bomberos, Serenazgo Huamanga).
8. **RadarAlertsScreen**: Alertas ciudadanas anónimas en el radio cercano.
9. **HistoryScreen**: Bitácora inmutable de eventos de incidentes.
10. **ProfileScreen**: Configuración de PIN de coacción y ajustes de privacidad.
