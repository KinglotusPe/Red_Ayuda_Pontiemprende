# Flujo de Emergencia — RED AYUDA

## 1. Demostración del Ciclo Completo (Víctima, Contacto y Centro de Control)

```mermaid
sequenceDiagram
    autonumber
    actor V as Víctima (Teléfono A)
    actor C as Contacto sin App (Teléfono B)
    participant B as Backend Spring Boot
    participant WS as WebSocket Broker
    actor A as Operador (Laptop Admin)

    V->>V: Mantiene presionado SOS (3s)
    V->>V: Cuenta regresiva de 10s (con botón Cancelar)
    Note over V: Termina cuenta regresiva
    V->>B: POST /emergencies/sos (Tipo, Coordenadas, Batería)
    Note over B: Crea emergencia inmediatamente
    B->>WS: Broadcast /topic/emergency/{id} & /topic/admin
    B->>C: Envío de SMS / WhatsApp con enlace /emergency/share/{token}
    WS->>A: Alerta en vivo en mapa de Centro de Control
    V->>V: Captura audio ambiental (5 segundos)
    V->>B: POST /emergencies/{id}/audio (Upload)
    C->>B: Abre enlace /emergency/share/{token}
    B->>C: Muestra mapa en vivo, batería y audio autorizado
    V->>B: POST /emergencies/{id}/location (Tracking periódico)
    B->>WS: Actualización de coordenadas
    WS->>C: Mapa web se actualiza en tiempo real
    WS->>A: Marcador se mueve en mapa operativo
    V->>B: POST /emergencies/{id}/cancel (PIN normal)
    B->>WS: Alerta marcada como CANCELADA / RESUELTA
```

## 2. Regla Crítica del Orden de Ejecución
NUNCA esperar a que el audio termine de grabarse para crear la emergencia.
1. Termina cuenta regresiva.
2. Crear emergencia inmediatamente en backend.
3. Guardar primera ubicación disponible.
4. Despachar avisos a contactos y usuarios cercanos.
5. Iniciar grabación y subida asíncrona del audio.
6. Mantener tracking periódico.
