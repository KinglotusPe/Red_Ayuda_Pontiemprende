import 'package:flutter_test/flutter_test.dart';
import 'package:red_ayuda/models/user_model.dart';
import 'package:red_ayuda/models/contact_model.dart';

void main() {
  group('Model Serialization Tests', () {
    test('UserModel fromJson and toJson serialization', () {
      final json = {
        'id': '12345',
        'nombres': 'Carlos',
        'apellidos': 'Mendoza',
        'email': 'carlos@redayuda.pe',
        'telefono': '+51966123456',
        'roles': ['ROLE_CIUDADANO'],
        'estadoVerificacion': 'VERIFICADO',
        'tienePinConfigurado': true,
      };

      final user = UserModel.fromJson(json);

      expect(user.id, '12345');
      expect(user.nombreCompleto, 'Carlos Mendoza');
      expect(user.tienePinConfigurado, true);

      final outJson = user.toJson();
      expect(outJson['email'], 'carlos@redayuda.pe');
    });

    test('ContactModel fromJson and toJson serialization', () {
      final json = {
        'id': 'contact-1',
        'nombre': 'María Flores',
        'telefono': '+51966654321',
        'email': 'maria@correo.pe',
        'parentesco': 'Hermana',
        'prioridad': 1,
        'tieneRedAyuda': true,
        'permiteUbicacionPrecisa': true,
        'permiteAudio': true,
        'activo': true,
      };

      final contact = ContactModel.fromJson(json);

      expect(contact.nombre, 'María Flores');
      expect(contact.permiteAudio, true);
      expect(contact.prioridad, 1);
    });
  });
}
