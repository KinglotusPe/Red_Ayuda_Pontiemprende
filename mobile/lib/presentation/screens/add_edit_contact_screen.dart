import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/api_service.dart';
import '../../core/services/emergency_state.dart';
import '../../models/contact_model.dart';

class AddEditContactScreen extends StatefulWidget {
  final ApiService apiService;

  const AddEditContactScreen({super.key, required this.apiService});

  @override
  State<AddEditContactScreen> createState() => _AddEditContactScreenState();
}

class _AddEditContactScreenState extends State<AddEditContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _emailController = TextEditingController();
  final _parentescoController = TextEditingController(text: 'Familiar');
  int _prioridad = 1;
  bool _permiteUbicacionPrecisa = true;
  bool _permiteAudio = true;
  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final contact = ContactModel(
      id: '',
      nombre: _nombreController.text.trim(),
      telefono: _telefonoController.text.trim(),
      email: _emailController.text.trim().isNotEmpty ? _emailController.text.trim() : null,
      parentesco: _parentescoController.text.trim(),
      prioridad: _prioridad,
      tieneRedAyuda: false,
      permiteUbicacionPrecisa: _permiteUbicacionPrecisa,
      permiteAudio: _permiteAudio,
      activo: true,
    );

    final success = await widget.apiService.addContact(contact);
    setState(() => _isLoading = false);

    if (!mounted) return;

    if (success) {
      await context.read<EmergencyState>().refreshContacts();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contacto de confianza agregado exitosamente')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al agregar el contacto')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Agregar Contacto de Auxilio')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre Completo', prefixIcon: Icon(Icons.person_outline)),
                validator: (v) => v == null || v.isEmpty ? 'Ingrese el nombre' : null,
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _telefonoController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Teléfono Móvil (+51)', prefixIcon: Icon(Icons.phone_outlined)),
                validator: (v) => v == null || v.length < 9 ? 'Teléfono inválido' : null,
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Correo Electrónico (Opcional)', prefixIcon: Icon(Icons.email_outlined)),
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _parentescoController,
                decoration: const InputDecoration(labelText: 'Parentesco / Vínculo (Madre, Hermano, Amigo)', prefixIcon: Icon(Icons.family_restroom_outlined)),
              ),
              const SizedBox(height: 20),

              // Permisos autorizados para este contacto
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Permisos de Transmisión de Datos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 10),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Permitir Ubicación Satelital Precisa', style: TextStyle(fontSize: 13)),
                      subtitle: const Text('Si se desactiva, solo recibirá zona aproximada', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                      value: _permiteUbicacionPrecisa,
                      activeColor: AppColors.emergencyRed,
                      onChanged: (v) => setState(() => _permiteUbicacionPrecisa = v),
                    ),
                    const Divider(color: AppColors.border),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Permitir Escucha de Audio de Emergencia (5s)', style: TextStyle(fontSize: 13)),
                      subtitle: const Text('Autoriza acceso mediante enlace web temporal firmado', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                      value: _permiteAudio,
                      activeColor: AppColors.emergencyRed,
                      onChanged: (v) => setState(() => _permiteAudio = v),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white))
                    : const Text('GUARDAR CONTACTO'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
