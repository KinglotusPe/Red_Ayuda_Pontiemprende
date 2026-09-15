# Especificación de la API REST — RED AYUDA

La API sigue los estándares REST y está documentada interactivamente vía Swagger / OpenAPI en `/swagger-ui.html`.

## 1. Autenticación (`/api/v1/auth`)

### Registrar Ciudadano
- **POST** `/register`
- **Request Body**:
```json
{
  "dni": "45892314",
  "nombres": "Carlos",
  "apellidos": "Mendoza Quispe",
  "telefono": "+51966123456",
  "email": "carlos@redayuda.pe",
  "password": "Password123!"
}
```
- **Response 201 Created**:
```json
{
  "accessToken": "eyJhbGciOi...",
  "refreshToken": "uuid-refresh-token",
  "tokenType": "Bearer",
  "expiresInMs": 900000,
  "user": { ... }
}
```

### Iniciar Sesión
- **POST** `/login`
- **Request Body**: `{"email": "carlos@redayuda.pe", "password": "Password123!"}`
- **Response 200 OK**: Tokens JWT y perfil del usuario.

### Configurar PIN Normal y PIN de Coacción
- **POST** `/pin/setup` (Requiere Bearer Token)
- **Request Body**:
```json
{
  "pin": "1234",
  "pinCoercion": "9999"
}
```
*Regla*: El PIN de coacción debe ser estrictamente diferente al normal.

---

## 2. Emergencias (`/api/v1/emergencies`)

### Disparar Alerta SOS Inmediata
- **POST** `/sos` (Requiere Bearer Token)
- **Request Body**:
```json
{
  "tipo": "ROBO",
  "latitud": -13.1631,
  "longitud": -74.2236,
  "precisionMetros": 12.5,
  "fuente": "GPS",
  "nivelBateria": 85
}
```
- **Acción**: Crea inmediatamente la emergencia, notifica contactos vía SMS/Push/WA y difunde por WebSocket.

### Actualizar Coordenadas de Tracking
- **POST** `/{id}/location`
- **Request Body**:
```json
{
  "latitud": -13.1645,
  "longitud": -74.2240,
  "precisionMetros": 10.0,
  "velocidadKmh": 5.2,
  "nivelBateria": 84
}
```

### Cancelar Emergencia (PIN Normal vs PIN Coacción)
- **POST** `/{id}/cancel`
- **Request Body**:
```json
{
  "pin": "1234",
  "motivo": "Cancelado voluntariamente"
}
```
*Si se ingresa el PIN de coacción (`9999`), el backend retorna apariencia de éxito (`CANCELADA`), pero la emergencia permanece `ACTIVA` en segundo plano con flag `posible_coaccion=true`.*

---

## 3. Seguimiento Público para Contactos sin App (`/api/v1/public`)

### Obtener Telemetría y Enlace de Audio Seguro
- **GET** `/share/{token}`
- **Response 200 OK**: Retorna ubicación satelital, batería, audio temporal firmado si está autorizado, y botones de llamada rápida a la Policía 105, SAMU 106 y Bomberos 116.
