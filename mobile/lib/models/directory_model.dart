class DirectoryItemModel {
  final String id;
  final String nombre;
  final String tipo;
  final String telefono;
  final String region;
  final String provincia;
  final String distrito;
  final int prioridad;

  DirectoryItemModel({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.telefono,
    required this.region,
    required this.provincia,
    required this.distrito,
    required this.prioridad,
  });

  factory DirectoryItemModel.fromJson(Map<String, dynamic> json) {
    return DirectoryItemModel(
      id: json['id'] ?? '',
      nombre: json['nombre'] ?? '',
      tipo: json['tipo'] ?? '',
      telefono: json['telefono'] ?? '',
      region: json['region'] ?? '',
      provincia: json['provincia'] ?? '',
      distrito: json['distrito'] ?? '',
      prioridad: json['prioridad'] ?? 1,
    );
  }
}
