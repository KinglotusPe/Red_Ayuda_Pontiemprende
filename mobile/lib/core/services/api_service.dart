import 'dart:convert';
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

  String? get accessToken => _accessToken;
  UserModel? get currentUser => _currentUser;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('access_token');
    final userJson = prefs.getString('current_user');
    if (userJson != null) {
      _currentUser = UserModel.fromJson(jsonDecode(userJson));
    }
  }

  Map<String, String> _headers({bool requiresAuth = true}) {
    final headers = {'Content-Type': 'application/json'};
    if (requiresAuth && _accessToken != null) {
      headers['Authorization'] = 'Bearer $_accessToken';
    }
    return headers;
  }

  // Autenticación
  Future<bool> register({
    required String dni,
    required String nombres,
    required String apellidos,
    required String telefono,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.register}'),
      headers: _headers(requiresAuth: false),
      body: jsonEncode({
        'dni': dni,
        'nombres': nombres,
        'apellidos': apellidos,
        'telefono': telefono,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      await _saveAuthData(data);
      return true;
    }
    return false;
  }

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.login}'),
      headers: _headers(requiresAuth: false),
      body: jsonEncode({
        'email': email,
        'password': password,
        'plataforma': 'ANDROID',
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _saveAuthData(data);
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _accessToken = null;
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
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
  }

  // Configuración de PIN
  Future<bool> setupPin(String pin, String pinCoercion) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.setupPin}'),
      headers: _headers(),
      body: jsonEncode({'pin': pin, 'pinCoercion': pinCoercion}),
    );
    return response.statusCode == 200;
  }

  Future<bool> verifyPin(String pin) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.verifyPin}'),
      headers: _headers(),
      body: jsonEncode({'pin': pin}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['valid'] == true;
    }
    return false;
  }

  // Ciclo de Emergencia
  Future<EmergencyModel?> triggerSos({
    String tipo = 'DESCONOCIDA',
    double? latitud,
    double? longitud,
    double? precisionMetros,
    int? nivelBateria,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.sos}'),
      headers: _headers(),
      body: jsonEncode({
        'tipo': tipo,
        'latitud': latitud ?? -13.1631, // Default Ayacucho si GPS tarda
        'longitud': longitud ?? -74.2236,
        'precisionMetros': precisionMetros ?? 15.0,
        'fuente': latitud != null ? 'GPS' : 'LAST_KNOWN',
        'nivelBateria': nivelBateria ?? 85,
      }),
    );

    if (response.statusCode == 201) {
      return EmergencyModel.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<bool> updateLocation(String emergencyId, double lat, double lon, double precision, int bateria) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.location}/$emergencyId/location'),
      headers: _headers(),
      body: jsonEncode({
        'latitud': lat,
        'longitud': lon,
        'precisionMetros': precision,
        'fuente': 'GPS',
        'nivelBateria': bateria,
      }),
    );
    return response.statusCode == 200;
  }

  Future<Map<String, dynamic>> cancelEmergency(String emergencyId, String pin) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.cancelEmergency}/$emergencyId/cancel'),
      headers: _headers(),
      body: jsonEncode({'pin': pin, 'motivo': 'Cancelación por usuario'}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception(response.body);
  }

  // Contactos de Confianza
  Future<List<ContactModel>> getContacts() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.contacts}'),
      headers: _headers(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> list = jsonDecode(response.body);
      return list.map((e) => ContactModel.fromJson(e)).toList();
    }
    return [];
  }

  Future<bool> addContact(ContactModel contact) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.contacts}'),
      headers: _headers(),
      body: jsonEncode(contact.toJson()),
    );
    return response.statusCode == 201;
  }

  Future<bool> deleteContact(String contactId) async {
    final response = await http.delete(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.contacts}/$contactId'),
      headers: _headers(),
    );
    return response.statusCode == 200;
  }

  // Directorio Oficial
  Future<List<DirectoryItemModel>> getDirectory() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.directory}?region=Ayacucho'),
      headers: _headers(requiresAuth: false),
    );

    if (response.statusCode == 200) {
      final List<dynamic> list = jsonDecode(response.body);
      return list.map((e) => DirectoryItemModel.fromJson(e)).toList();
    }
    return [];
  }

  // Radar Cercano
  Future<List<NearbyAlertModel>> getNearbyAlerts(double lat, double lon) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.radar}?lat=$lat&lon=$lon&maxRadiusMeters=2000'),
      headers: _headers(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> list = jsonDecode(response.body);
      return list.map((e) => NearbyAlertModel.fromJson(e)).toList();
    }
    return [];
  }

  // Historial
  Future<List<EmergencyModel>> getHistory() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.history}'),
      headers: _headers(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> list = jsonDecode(response.body);
      return list.map((e) => EmergencyModel.fromJson(e)).toList();
    }
    return [];
  }
}
