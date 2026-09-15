class ApiConstants {
  // Configuración base de la API
  // Para emulador Android: 10.0.2.2:8080
  // Para iOS simulador: localhost:8080
  // Para dispositivo físico: IP local o dominio de producción
  static const String baseUrl = 'http://10.0.2.2:8080/api/v1';
  static const String wsUrl = 'ws://10.0.2.2:8080/ws-emergency/websocket';

  // Endpoints
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String refreshToken = '/auth/refresh-token';
  static const String setupPin = '/auth/pin/setup';
  static const String verifyPin = '/auth/pin/verify';

  static const String sos = '/emergencies/sos';
  static const String location = '/emergencies';
  static const String audio = '/emergencies';
  static const String cancelEmergency = '/emergencies';
  static const String history = '/emergencies/history';

  static const String contacts = '/contacts';
  static const String directory = '/directory';
  static const String radar = '/radar/nearby-alerts';
}
