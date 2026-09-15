import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/api_service.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  final ApiService apiService;

  const RegisterScreen({super.key, required this.apiService});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dniController = TextEditingController();
  final _nombresController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final success = await widget.apiService.register(
      dni: _dniController.text.trim(),
      nombres: _nombresController.text.trim(),
      apellidos: _apellidosController.text.trim(),
      telefono: _telefonoController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
    setState(() => _isLoading = false);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro exitoso. ¡Bienvenido a RED AYUDA!')),
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => HomeScreen(apiService: widget.apiService)),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al registrar usuario. Verifique sus datos.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Registro de Ciudadano')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Datos de Identidad y Contacto',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 6),
              const Text(
                'Su DNI y número telefónico están protegidos y nunca serán públicos.',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _dniController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'DNI (8 dígitos)', prefixIcon: Icon(Icons.badge_outlined)),
                validator: (v) => v == null || v.length < 8 ? 'DNI inválido' : null,
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _nombresController,
                decoration: const InputDecoration(labelText: 'Nombres', prefixIcon: Icon(Icons.person_outline)),
                validator: (v) => v == null || v.isEmpty ? 'Ingrese sus nombres' : null,
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _apellidosController,
                decoration: const InputDecoration(labelText: 'Apellidos', prefixIcon: Icon(Icons.family_restroom_outlined)),
                validator: (v) => v == null || v.isEmpty ? 'Ingrese sus apellidos' : null,
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
                decoration: const InputDecoration(labelText: 'Correo Electrónico', prefixIcon: Icon(Icons.email_outlined)),
                validator: (v) => v == null || !v.contains('@') ? 'Correo inválido' : null,
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Contraseña (mínimo 8 caracteres)', prefixIcon: Icon(Icons.lock_outline)),
                validator: (v) => v == null || v.length < 8 ? 'Mínimo 8 caracteres' : null,
              ),
              const SizedBox(height: 28),

              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white))
                    : const Text('CREAR CUENTA SEGURA'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
