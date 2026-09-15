class UserModel {
  final String id;
  final String nombres;
  final String apellidos;
  final String email;
  final String telefono;
  final List<String> roles;
  final String estadoVerificacion;
  final bool tienePinConfigurado;

  UserModel({
    required this.id,
    required this.nombres,
    required this.apellidos,
    required this.email,
    required this.telefono,
    required this.roles,
    required this.estadoVerificacion,
    required this.tienePinConfigurado,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      nombres: json['nombres'] ?? '',
      apellidos: json['apellidos'] ?? '',
      email: json['email'] ?? '',
      telefono: json['telefono'] ?? '',
      roles: (json['roles'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      estadoVerificacion: json['estadoVerificacion'] ?? 'PENDIENTE',
      tienePinConfigurado: json['tienePinConfigurado'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombres': nombres,
      'apellidos': apellidos,
      'email': email,
      'telefono': telefono,
      'roles': roles,
      'estadoVerificacion': estadoVerificacion,
      'tienePinConfigurado': tienePinConfigurado,
    };
  }

  String get nombreCompleto => '$nombres $apellidos'.trim();
}
