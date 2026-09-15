# Protocolos de Seguridad y Privacidad — RED AYUDA

## 1. Protección de Datos Sensibles
- **DNI**: Almacenado como identificador único pero **nunca** expuesto en respuestas de radar ni compartido a contactos sin permiso explícito.
- **Contraseñas y PINs**: Hasheados usando **BCrypt** con factor de costo 10. Nunca se persisten en texto plano ni se incluyen en logs.
- **Grabaciones de audio**: Guardadas en buckets privados. El acceso requiere **Pre-signed URLs** temporales de 15 minutos que solo se entregan a la víctima o contactos con `permite_audio = true`.
- **Alertas de Radar Cercano**: Ofuscadas para evitar revelar la identidad o la posición milimétrica exacta de la víctima a terceros.

## 2. Mecanismo de PIN de Coacción
Diseñado para proteger la integridad física de la persona si un delincuente o agresor la fuerza a cancelar la alarma bajo amenaza:
- La víctima ingresa su **PIN de coacción** configurado previamente (ej. `9999`).
- La aplicación móvil muestra inmediatamente un mensaje falso de éxito: *"Emergencia finalizada con éxito"*, cerrando la pantalla de alarma ante la vista del agresor.
- El backend **rechaza** la finalización, mantiene la alerta **ACTIVA**, marca la bandera `posible_coaccion = true` y despacha un SMS silencioso de socorro a los contactos de confianza.

## 3. Tokens Criptográficos de Compartición Web
- Los enlaces web para contactos que no tienen la aplicación instalada (`/emergency/share/{token}`) utilizan un token aleatorio seguro de 32 bytes (64 caracteres hexadecimales) generado mediante `SecureRandom`.
- Tienen una validez configurable de 24 horas y pueden ser revocados en cualquier momento por el usuario.
