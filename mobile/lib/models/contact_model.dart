class ContactModel {
  final String id;
  final String nombre;
  final String telefono;
  final String? email;
  final String? parentesco;
  final int prioridad;
  final bool tieneRedAyuda;
  final bool permiteUbicacionPrecisa;
  final bool permiteAudio;
  final bool activo;

  ContactModel({
    required this.id,
    required this.nombre,
    required this.telefono,
    this.email,
    this.parentesco,
    required this.prioridad,
    required this.tieneRedAyuda,
    required this.permiteUbicacionPrecisa,
    required this.permiteAudio,
    required this.activo,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'] ?? '',
      nombre: json['nombre'] ?? '',
      telefono: json['telefono'] ?? '',
      email: json['email'],
      parentesco: json['parentesco'],
      prioridad: json['prioridad'] ?? 1,
      tieneRedAyuda: json['tieneRedAyuda'] ?? false,
      permiteUbicacionPrecisa: json['permiteUbicacionPrecisa'] ?? true,
      permiteAudio: json['permiteAudio'] ?? true,
      activo: json['activo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'telefono': telefono,
      'email': email,
      'parentesco': parentesco,
      'prioridad': prioridad,
      'permiteUbicacionPrecisa': permiteUbicacionPrecisa,
      'permiteAudio': permiteAudio,
    };
  }
}
