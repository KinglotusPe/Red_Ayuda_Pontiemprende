# Límites y Consideraciones de Plataforma — RED AYUDA

En estricto cumplimiento de las prohibiciones de diseño y honestidad técnica:

1. **Integración con RENIEC**:
   - Actualmente no existe integración con los servicios web oficiales del Registro Nacional de Identificación y Estado Civil (RENIEC) por requerir convenios institucionales estatales. El sistema valida el formato de 8 dígitos y provee una abstracción extensible para conectores de verificación de identidad futuros.

2. **Geolocalización por Antenas de Operador Celular**:
   - El sistema NO realiza triangulación de celdas de operadoras telefónicas (Claro, Movistar, Entel, Bitel), ya que esto requeriría acuerdos directos a nivel de red troncal con las empresas de telecomunicaciones. La redundancia se basa en: GPS de alta precisión, ubicación aproximada por Wi-Fi/red celular del sistema operativo (`NETWORK`), y última posición conocida (`LAST_KNOWN`).

3. **Llamadas Telefónicas**:
   - Tanto Google Play como Apple App Store prohíben estrictamente que una aplicación privada realice llamadas telefónicas silenciosas o automáticas sin la intervención explícita del usuario. La app abre el marcador oficial (`DIAL` intent / `tel://`) con el número premarcado (105, 106, 116) para que el usuario confirme con un solo toque.

4. **Mensajería SMS y WhatsApp**:
   - Sin credenciales de pago activas (Twilio, AWS SNS, Meta Cloud API), el sistema opera en modo `DEV_MOCK`, registrando explícitamente en base de datos y consola: `[SIMULADO_DEV - NO ENVIADO REALMENTE]`. Nunca se afirma erróneamente que un mensaje fue entregado si solo fue simulado.

5. **Compilación de iOS**:
   - Mientras no se suministren certificados y perfiles de aprovisionamiento de una cuenta activa del Apple Developer Program, los builds de iOS en GitHub Actions se generan como `UNSIGNED` para validación técnica de compilación.
