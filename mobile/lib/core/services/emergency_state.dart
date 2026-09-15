import 'package:flutter/material.dart';
import '../../models/emergency_model.dart';
import '../../models/contact_model.dart';
import 'api_service.dart';

enum ProtectionLevel {
  completa,
  limitada,
}

class EmergencyState extends ChangeNotifier {
  final ApiService _apiService;

  EmergencyModel? _activeEmergency;
  List<ContactModel> _contacts = [];
  bool _isLoading = false;
  String _selectedEmergencyType = 'ROBO';

  // Estados de Protección
  bool _locationEnabled = true;
  bool _notificationsEnabled = true;
  bool _microphoneEnabled = true;
  bool _voiceEnabled = false;

  EmergencyState(this._apiService);

  EmergencyModel? get activeEmergency => _activeEmergency;
  List<ContactModel> get contacts => _contacts;
  bool get isLoading => _isLoading;
  String get selectedEmergencyType => _selectedEmergencyType;

  bool get locationEnabled => _locationEnabled;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get microphoneEnabled => _microphoneEnabled;
  bool get voiceEnabled => _voiceEnabled;

  ProtectionLevel get protectionLevel {
    if (_locationEnabled && _contacts.isNotEmpty && _notificationsEnabled && _microphoneEnabled) {
      return ProtectionLevel.completa;
    }
    return ProtectionLevel.limitada;
  }

  void setSelectedEmergencyType(String type) {
    _selectedEmergencyType = type;
    notifyListeners();
  }

  Future<void> loadInitialData() async {
    _isLoading = true;
    notifyListeners();
    try {
      _contacts = await _apiService.getContacts();
    } catch (e) {
      debugPrint('Error loading initial data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<EmergencyModel?> triggerSos() async {
    _isLoading = true;
    notifyListeners();
    try {
      final emergency = await _apiService.triggerSos(
        tipo: _selectedEmergencyType,
        latitud: -13.1631, // Coordenadas Ayacucho
        longitud: -74.2236,
        precisionMetros: 12.0,
        nivelBateria: 85,
      );
      _activeEmergency = emergency;
      return emergency;
    } catch (e) {
      debugPrint('Error triggering SOS: $e');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> cancelEmergency(String pin) async {
    if (_activeEmergency == null) return false;
    _isLoading = true;
    notifyListeners();
    try {
      final result = await _apiService.cancelEmergency(_activeEmergency!.id, pin);
      // Si fue cancelada normalmente o coacción simulada
      if (result['estado'] == 'CANCELADA') {
        _activeEmergency = null;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error cancelling emergency: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setActiveEmergency(EmergencyModel? emergency) {
    _activeEmergency = emergency;
    notifyListeners();
  }

  Future<void> refreshContacts() async {
    _contacts = await _apiService.getContacts();
    notifyListeners();
  }
}
