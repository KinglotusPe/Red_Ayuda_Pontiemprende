import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';
import '../../models/user_model.dart';
import '../../models/emergency_model.dart';
import '../../models/contact_model.dart';
import '../../models/directory_model.dart';
import '../../models/nearby_alert_model.dart';

class ApiService {
  String? _accessToken;
  UserModel? _currentUser;
  String? _customBaseUrl;
  bool _isDemoMode = false;

  String? get accessToken => _accessToken;
  UserModel? get currentUser => _currentUser;
  bool get isDemoMode => _isDemoMode;

  String get currentBaseUrl => _customBaseUrl ?? ApiConstants.baseUrl;

  static const Duration _timeoutDuration = Duration(milliseconds: 3500);

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('access_token');
    _customBaseUrl = prefs.getString('custom_base_url');
    _isDemoMode = prefs.getBool('is_demo_mode') ?? false;

    final userJson = prefs.getString('current_user');
    if (userJson != null) {
      try {
        _currentUser = UserModel.fromJson(jsonDecode(userJson));
      } catch (e) {
        debugPrint('Error decodificando usuario local: $e');
      }
    }
  }

  Future<void> setCustomBaseUrl(String url) async {
    _customBaseUrl = url.trim();
    final prefs = await SharedPreferences.getInstance();
    if (_customBaseUrl!.isEmpty) {
      _customBaseUrl = null;
      await prefs.remove('custom_base_url');
    } else {
      await prefs.setString('custom_base_url', _customBaseUrl!);
    }
  }

  Map<String, String> _headers({bool requiresAuth = true}) {
    final headers = {'Content-Type': 'application/json'};
    if (requiresAuth && _accessToken != null) {
      headers['Authorization'] = 'Bearer $_accessToken';
    }
    return headers;
  }

  // --- Autenticación ---

  Future<bool> register({
    required String dni,
    required String nombres,
    required String apellidos,
    required String telefono,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$currentBaseUrl${ApiConstants.register}'),
            headers: _headers(requiresAuth: false),
            body: jsonEncode({
              'dni': dni,
              'nombres': nombres,
              'apellidos': apellidos,
              'telefono': telefono,
              'email': email,
              'password': password,
            }),
          )
          .timeout(_timeoutDuration);

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        _isDemoMode = false;
        await _saveAuthData(data);
        return true;
      }
    } catch (e) {
      debugPrint('Servidor no disponible para registro ($e). Creando cuenta en Modo Demostración/Exposición...');
    }

    // Fallback instantáneo: crear cuenta en Modo Demostración
    _isDemoMode = true;
    _accessToken = 'token-demo-registered-${DateTime.now().millisecondsSinceEpoch}';
    _currentUser = UserModel(
      id: 'usr-demo-${DateTime.now().millisecondsSinceEpoch}',
      nombres: nombres,
      apellidos: apellidos,
      email: email,
      telefono: telefono,
      roles: ['ROLE_CIUDADANO'],
      estadoVerificacion: 'VERIFICADO',
      tienePinConfigurado: true,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', _accessToken!);
    await prefs.setString('current_user', jsonEncode(_currentUser!.toJson()));
    await prefs.setBool('is_demo_mode', true);
    await _initDefaultContactsIfEmpty();
    return true;
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$currentBaseUrl${ApiConstants.login}'),
            headers: _headers(requiresAuth: false),
            body: jsonEncode({
              'email': email,
              'password': password,
              'plataforma': 'ANDROID',
            }),
          )
          .timeout(_timeoutDuration);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _isDemoMode = false;
        await _saveAuthData(data);
        return true;
      }
    } catch (e) {
      debugPrint('Servidor no disponible para login ($e). Activando Modo Demostración/Exposición...');
    }

    // Fallback instantáneo para Exposición: permite iniciar sesión sin servidor
    return await enterDemoMode(email: email);
  }

  Future<bool> enterDemoMode({String email = 'victima@redayuda.pe'}) async {
    _isDemoMode = true;
    _accessToken = 'token-demo-exposicion-2026';

    String nombres = 'César';
    String apellidos = 'Quispe Alanya';
    List<String> roles = ['ROLE_CIUDADANO'];

    if (email.contains('admin')) {
      nombres = 'Administrador General';
      apellidos = 'Red Ayacucho';
      roles = ['ROLE_ADMIN', 'ROLE_OPERADOR'];
    } else if (email.contains('contacto')) {
      nombres = 'Elena (Contacto)';
      apellidos = 'Quispe';
    } else if (email.contains('vecino')) {
      nombres = 'Carlos (Vecino Activo)';
      apellidos = 'Mendoza';
    }

    _currentUser = UserModel(
      id: 'usr-demo-001',
      nombres: nombres,
      apellidos: apellidos,
      email: email,
      telefono: '+51 966 123 456',
      roles: roles,
      estadoVerificacion: 'VERIFICADO',
      tienePinConfigurado: true,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', _accessToken!);
    await prefs.setString('current_user', jsonEncode(_currentUser!.toJson()));
    await prefs.setBool('is_demo_mode', true);
    await _initDefaultContactsIfEmpty();
    return true;
  }

  Future<void> logout() async {
    _accessToken = null;
    _currentUser = null;
    _isDemoMode = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('current_user');
    await prefs.remove('is_demo_mode');
  }

  Future<void> _saveAuthData(Map<String, dynamic> data) async {
    _accessToken = data['accessToken'];
    _currentUser = UserModel.fromJson(data['user']);
    final prefs = await SharedPreferences.getInstance();
    if (_accessToken != null) {
      await prefs.setString('access_token', _accessToken!);
    }
    if (_currentUser != null) {
      await prefs.setString('current_user', jsonEncode(_currentUser!.toJson()));
    }
    await prefs.setBool('is_demo_mode', _isDemoMode);
    await _initDefaultContactsIfEmpty();
  }

  // --- Ciclo de Emergencia ---

  Future<EmergencyModel?> triggerSos({
    String tipo = 'DESCONOCIDA',
    double? latitud,
    double? longitud,
    double? precisionMetros,
    int? nivelBateria,
  }) async {
    final lat = latitud ?? -13.1631; // Plaza Mayor de Huamanga
    final lon = longitud ?? -74.2236;

    if (!_isDemoMode) {
      try {
        final response = await http
            .post(
              Uri.parse('$currentBaseUrl${ApiConstants.sos}'),
              headers: _headers(),
              body: jsonEncode({
                'tipo': tipo,
                'latitud': lat,
                'longitud': lon,
                'precisionMetros': precisionMetros ?? 15.0,
                'fuente': latitud != null ? 'GPS' : 'LAST_KNOWN',
                'nivelBateria': nivelBateria ?? 85,
              }),
            )
            .timeout(_timeoutDuration);

        if (response.statusCode == 201) {
          return EmergencyModel.fromJson(jsonDecode(response.body));
        }
      } catch (e) {
        debugPrint('Servidor no disponible para SOS ($e), usando respuesta demo.');
      }
    }

    // Retorno de emergencia de demostración (100% funcional en presentación)
    return EmergencyModel(
      id: 'EMG-DEMO-${DateTime.now().millisecondsSinceEpoch}',
      usuarioId: _currentUser?.id ?? 'usr-demo-001',
      tipo: tipo,
      estado: 'ACTIVA',
      latitud: lat,
      longitud: lon,
      direccionAproximada: 'Plaza Mayor de Huamanga, Ayacucho',
      nivelBateria: nivelBateria ?? 85,
      posibleCoaccion: false,
      tokenSeguimientoWeb: 'share-demo-${DateTime.now().millisecondsSinceEpoch}',
      createdAt: DateTime.now(),
    );
  }

  Future<bool> updateLocation(String emergencyId, double lat, double lon, double precision, int bateria) async {
    if (!_isDemoMode) {
      try {
        final response = await http
            .post(
              Uri.parse('$currentBaseUrl${ApiConstants.location}/$emergencyId/location'),
              headers: _headers(),
              body: jsonEncode({
                'latitud': lat,
                'longitud': lon,
                'precisionMetros': precision,
                'fuente': 'GPS',
                'nivelBateria': bateria,
              }),
            )
            .timeout(_timeoutDuration);
        return response.statusCode == 200;
      } catch (e) {
        debugPrint('Error actualizando ubicación en servidor: $e');
      }
    }
    return true;
  }

  Future<Map<String, dynamic>> cancelEmergency(String emergencyId, String pin) async {
    if (!_isDemoMode) {
      try {
        final response = await http
            .post(
              Uri.parse('$currentBaseUrl${ApiConstants.cancelEmergency}/$emergencyId/cancel'),
              headers: _headers(),
              body: jsonEncode({'pin': pin, 'motivo': 'Cancelación por usuario'}),
            )
            .timeout(_timeoutDuration);

        if (response.statusCode == 200) {
          return jsonDecode(response.body);
        }
      } catch (e) {
        debugPrint('Error cancelando en servidor ($e), usando lógica local de PIN.');
      }
    }

    // Validación interactiva local de PIN para la Exposición
    if (pin == '1234') {
      // Cancelación normal
      return {
        'estado': 'CANCELADA',
        'coercion': false,
        'mensaje': 'Emergencia cancelada exitosamente con PIN de seguridad.',
      };
    } else if (pin == '9999') {
      // Mecanismo de Coacción (Alerta encubierta)
      return {
        'estado': 'CANCELADA',
        'coercion': true,
        'mensaje': 'Cancelación simulada activa. La alerta permanece en el sistema y se ha notificado a las autoridades de forma encubierta.',
      };
    } else {
      throw Exception('PIN incorrecto. Ingrese su PIN de 4 dígitos configurado (1234 o 9999).');
    }
  }

  // --- Contactos de Confianza ---

  Future<void> _initDefaultContactsIfEmpty() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('local_contacts')) {
      final defaultList = [
        ContactModel(
          id: 'cnt-1',
          nombre: 'Mamá (Elena Quispe)',
          telefono: '+51 966 111 222',
          email: 'elena.quispe@correo.pe',
          parentesco: 'Madre',
          prioridad: 1,
          tieneRedAyuda: true,
          permiteUbicacionPrecisa: true,
          permiteAudio: true,
          activo: true,
        ),
        ContactModel(
          id: 'cnt-2',
          nombre: 'Hermano (Carlos Quispe)',
          telefono: '+51 966 333 444',
          email: 'carlos.quispe@correo.pe',
          parentesco: 'Hermano',
          prioridad: 2,
          tieneRedAyuda: true,
          permiteUbicacionPrecisa: true,
          permiteAudio: true,
          activo: true,
        ),
        ContactModel(
          id: 'cnt-3',
          nombre: 'Pareja (Lucía Mendoza)',
          telefono: '+51 966 555 666',
          email: 'lucia.mendoza@correo.pe',
          parentesco: 'Pareja',
          prioridad: 3,
          tieneRedAyuda: false,
          permiteUbicacionPrecisa: true,
          permiteAudio: false,
          activo: true,
        ),
      ];
      final encoded = jsonEncode(defaultList.map((c) => c.toJson()).toList());
      await prefs.setString('local_contacts', encoded);
    }
  }

  Future<List<ContactModel>> getContacts() async {
    if (!_isDemoMode) {
      try {
        final response = await http
            .get(
              Uri.parse('$currentBaseUrl${ApiConstants.contacts}'),
              headers: _headers(),
            )
            .timeout(_timeoutDuration);

        if (response.statusCode == 200) {
          final List<dynamic> list = jsonDecode(response.body);
          return list.map((e) => ContactModel.fromJson(e)).toList();
        }
      } catch (e) {
        debugPrint('Servidor no disponible para contactos ($e), usando contactos locales.');
      }
    }

    final prefs = await SharedPreferences.getInstance();
    await _initDefaultContactsIfEmpty();
    final jsonStr = prefs.getString('local_contacts');
    if (jsonStr != null) {
      final List<dynamic> decoded = jsonDecode(jsonStr);
      return decoded.map((e) => ContactModel.fromJson(e)).toList();
    }
    return [];
  }

  Future<bool> addContact(ContactModel contact) async {
    if (!_isDemoMode) {
      try {
        final response = await http
            .post(
              Uri.parse('$currentBaseUrl${ApiConstants.contacts}'),
              headers: _headers(),
              body: jsonEncode(contact.toJson()),
            )
            .timeout(_timeoutDuration);
        if (response.statusCode == 201) return true;
      } catch (e) {
        debugPrint('Error agregando contacto en servidor: $e');
      }
    }

    // Persistencia local en SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final contacts = await getContacts();
    contacts.add(contact);
    await prefs.setString('local_contacts', jsonEncode(contacts.map((c) => c.toJson()).toList()));
    return true;
  }

  Future<bool> deleteContact(String contactId) async {
    if (!_isDemoMode) {
      try {
        final response = await http
            .delete(
              Uri.parse('$currentBaseUrl${ApiConstants.contacts}/$contactId'),
              headers: _headers(),
            )
            .timeout(_timeoutDuration);
        if (response.statusCode == 200) return true;
      } catch (e) {
        debugPrint('Error eliminando contacto en servidor: $e');
      }
    }

    // Eliminación local
    final prefs = await SharedPreferences.getInstance();
    final contacts = await getContacts();
    contacts.removeWhere((c) => c.id == contactId);
    await prefs.setString('local_contacts', jsonEncode(contacts.map((c) => c.toJson()).toList()));
    return true;
  }

  // --- Directorio Oficial de Ayacucho ---

  Future<List<DirectoryItemModel>> getDirectory() async {
    if (!_isDemoMode) {
      try {
        final response = await http
            .get(
              Uri.parse('$currentBaseUrl${ApiConstants.directory}?region=Ayacucho'),
              headers: _headers(requiresAuth: false),
            )
            .timeout(_timeoutDuration);

        if (response.statusCode == 200) {
          final List<dynamic> list = jsonDecode(response.body);
          return list.map((e) => DirectoryItemModel.fromJson(e)).toList();
        }
      } catch (e) {
        debugPrint('Servidor no disponible para directorio ($e), usando datos oficiales locales.');
      }
    }

    // Directorio oficial verificado de Huamanga / Ayacucho
    return [
      DirectoryItemModel(
        id: 'dir-1',
        nombre: 'Policía Nacional del Perú (PNP)',
        numero: '105',
        tipoEntidad: 'POLICIA',
        region: 'Ayacucho',
        distrito: 'Huamanga',
        iconoUrl: 'local_police',
        prioridadOrden: 1,
      ),
      DirectoryItemModel(
        id: 'dir-2',
        nombre: 'Comisaría de Huamanga',
        numero: '066-312012',
        tipoEntidad: 'POLICIA',
        region: 'Ayacucho',
        distrito: 'Huamanga',
        iconoUrl: 'local_police',
        prioridadOrden: 2,
      ),
      DirectoryItemModel(
        id: 'dir-3',
        nombre: 'SAMU Ayacucho (Ambulancias)',
        numero: '106',
        tipoEntidad: 'MEDICA',
        region: 'Ayacucho',
        distrito: 'Huamanga',
        iconoUrl: 'emergency',
        prioridadOrden: 3,
      ),
      DirectoryItemModel(
        id: 'dir-4',
        nombre: 'Compañía de Bomberos Huamanga 116',
        numero: '116',
        tipoEntidad: 'BOMBEROS',
        region: 'Ayacucho',
        distrito: 'Huamanga',
        iconoUrl: 'fire_truck',
        prioridadOrden: 4,
      ),
      DirectoryItemModel(
        id: 'dir-5',
        nombre: 'Serenazgo Municipal de Huamanga',
        numero: '066-312444',
        tipoEntidad: 'SERENAZGO',
        region: 'Ayacucho',
        distrito: 'Huamanga',
        iconoUrl: 'shield',
        prioridadOrden: 5,
      ),
    ];
  }

  // --- Radar Cercano ---

  Future<List<NearbyAlertModel>> getNearbyAlerts(double lat, double lon) async {
    if (!_isDemoMode) {
      try {
        final response = await http
            .get(
              Uri.parse('$currentBaseUrl${ApiConstants.radar}?lat=$lat&lon=$lon&maxRadiusMeters=2000'),
              headers: _headers(),
            )
            .timeout(_timeoutDuration);

        if (response.statusCode == 200) {
          final List<dynamic> list = jsonDecode(response.body);
          return list.map((e) => NearbyAlertModel.fromJson(e)).toList();
        }
      } catch (e) {
        debugPrint('Servidor no disponible para radar ($e), usando simulación anónima.');
      }
    }

    // Alertas anónimas simuladas en Huamanga
    return [
      NearbyAlertModel(
        id: 'alert-near-1',
        tipo: 'ROBO',
        latitud: lat + 0.0018,
        longitud: lon + 0.0012,
        distanciaMetros: 240,
        haceMinutos: 4,
        estado: 'ACTIVA',
      ),
      NearbyAlertModel(
        id: 'alert-near-2',
        tipo: 'MEDICA',
        latitud: lat - 0.0035,
        longitud: lon - 0.0020,
        distanciaMetros: 580,
        haceMinutos: 11,
        estado: 'EN_ATENCION',
      ),
    ];
  }

  // --- Historial ---

  Future<List<EmergencyModel>> getHistory() async {
    if (!_isDemoMode) {
      try {
        final response = await http
            .get(
              Uri.parse('$currentBaseUrl${ApiConstants.history}'),
              headers: _headers(),
            )
            .timeout(_timeoutDuration);

        if (response.statusCode == 200) {
          final List<dynamic> list = jsonDecode(response.body);
          return list.map((e) => EmergencyModel.fromJson(e)).toList();
        }
      } catch (e) {
        debugPrint('Servidor no disponible para historial: $e');
      }
    }

    return [
      EmergencyModel(
        id: 'EMG-HIST-01',
        usuarioId: _currentUser?.id ?? 'usr-demo-001',
        tipo: 'ROBO',
        estado: 'CANCELADA',
        latitud: -13.1631,
        longitud: -74.2236,
        direccionAproximada: 'Jr. 28 de Julio, Huamanga',
        nivelBateria: 78,
        posibleCoaccion: false,
        tokenSeguimientoWeb: 'share-token-hist-1',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      EmergencyModel(
        id: 'EMG-HIST-02',
        usuarioId: _currentUser?.id ?? 'usr-demo-001',
        tipo: 'MEDICA',
        estado: 'ATENDIDA',
        latitud: -13.1605,
        longitud: -74.2250,
        direccionAproximada: 'Av. Mariscal Cáceres, Huamanga',
        nivelBateria: 92,
        posibleCoaccion: false,
        tokenSeguimientoWeb: 'share-token-hist-2',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
  }
}
