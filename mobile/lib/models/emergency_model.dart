class EmergencyLocation {
  final double latitud;
  final double longitud;
  final double? precisionMetros;
  final String fuente;
  final String estadoMovimiento;
  final double? velocidadKmh;
  final String timestamp;

  EmergencyLocation({
    required this.latitud,
    required this.longitud,
    this.precisionMetros,
    required this.fuente,
    required this.estadoMovimiento,
    this.velocidadKmh,
    required this.timestamp,
  });

  factory EmergencyLocation.fromJson(Map<String, dynamic> json) {
    return EmergencyLocation(
      latitud: (json['latitud'] as num).toDouble(),
      longitud: (json['longitud'] as num).toDouble(),
      precisionMetros: json['precisionMetros'] != null ? (json['precisionMetros'] as num).toDouble() : null,
      fuente: json['fuente'] ?? 'GPS',
      estadoMovimiento: json['estadoMovimiento'] ?? 'QUIETO',
      velocidadKmh: json['velocidadKmh'] != null ? (json['velocidadKmh'] as num).toDouble() : null,
      timestamp: json['timestamp'] ?? '',
    );
  }
}

class EmergencyEvent {
  final String tipoEvento;
  final String? metadataJson;
  final String timestamp;

  EmergencyEvent({
    required this.tipoEvento,
    this.metadataJson,
    required this.timestamp,
  });

  factory EmergencyEvent.fromJson(Map<String, dynamic> json) {
    return EmergencyEvent(
      tipoEvento: json['tipoEvento'] ?? '',
      metadataJson: json['metadataJson'],
      timestamp: json['timestamp'] ?? '',
    );
  }
}

class EmergencyModel {
  final String id;
  final String usuarioId;
  final String usuarioNombre;
  final String tipo;
  final String estado;
  final bool posibleCoaccion;
  final int? nivelBateria;
  final bool dispositivoOffline;
  final String fechaInicio;
  final String? fechaCierre;
  final EmergencyLocation? ultimaUbicacion;
  final List<EmergencyEvent> eventos;
  final String? shareUrl;
  final String? audioSignedUrl;

  EmergencyModel({
    required this.id,
    required this.usuarioId,
    required this.usuarioNombre,
    required this.tipo,
    required this.estado,
    required this.posibleCoaccion,
    this.nivelBateria,
    required this.dispositivoOffline,
    required this.fechaInicio,
    this.fechaCierre,
    this.ultimaUbicacion,
    required this.eventos,
    this.shareUrl,
    this.audioSignedUrl,
  });

  factory EmergencyModel.fromJson(Map<String, dynamic> json) {
    return EmergencyModel(
      id: json['id'] ?? '',
      usuarioId: json['usuarioId'] ?? '',
      usuarioNombre: json['usuarioNombre'] ?? '',
      tipo: json['tipo'] ?? 'DESCONOCIDA',
      estado: json['estado'] ?? 'CREADA',
      posibleCoaccion: json['posibleCoaccion'] ?? false,
      nivelBateria: json['nivelBateria'],
      dispositivoOffline: json['dispositivoOffline'] ?? false,
      fechaInicio: json['fechaInicio'] ?? '',
      fechaCierre: json['fechaCierre'],
      ultimaUbicacion: json['ultimaUbicacion'] != null
          ? EmergencyLocation.fromJson(json['ultimaUbicacion'])
          : null,
      eventos: (json['eventos'] as List<dynamic>?)
              ?.map((e) => EmergencyEvent.fromJson(e))
              .toList() ??
          [],
      shareUrl: json['shareUrl'],
      audioSignedUrl: json['audioSignedUrl'],
    );
  }
}
