class NearbyAlertModel {
  final String id;
  final String tipo;
  final double distanciaAproximadaMetros;
  final String zonaAproximada;
  final String timestamp;
  final String estado;

  NearbyAlertModel({
    required this.id,
    required this.tipo,
    required this.distanciaAproximadaMetros,
    required this.zonaAproximada,
    required this.timestamp,
    required this.estado,
  });

  factory NearbyAlertModel.fromJson(Map<String, dynamic> json) {
    return NearbyAlertModel(
      id: json['id'] ?? '',
      tipo: json['tipo'] ?? 'DESCONOCIDA',
      distanciaAproximadaMetros: (json['distanciaAproximadaMetros'] as num?)?.toDouble() ?? 0.0,
      zonaAproximada: json['zonaAproximada'] ?? 'Zona cercana',
      timestamp: json['timestamp'] ?? '',
      estado: json['estado'] ?? 'ACTIVA',
    );
  }
}
