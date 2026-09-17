import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/api_service.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  final ApiService apiService;

  const LoginScreen({super.key, required this.apiService});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'victima@redayuda.pe');
  final _passwordController = TextEditingController(text: 'Admin123456!');
  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final success = await widget.apiService.login(
      _emailController.text.trim(),
      _passwordController.text,
    );
    setState(() => _isLoading = false);

    if (!mounted) return;

    if (success) {
      if (widget.apiService.isDemoMode) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color(0xFF1E3A8A),
            content: Text('✨ Conectado en Modo Exposición (Demo local sin servidor). ¡Todo funcional!'),
            duration: Duration(seconds: 3),
          ),
        );
      }
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeScreen(apiService: widget.apiService)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Credenciales incorrectas. Verifique correo y contraseña.')),
      );
    }
  }

  Future<void> _enterQuickDemo() async {
    setState(() => _isLoading = true);
    await widget.apiService.enterDemoMode(email: _emailController.text.trim());
    setState(() => _isLoading = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Color(0xFF1E3A8A),
        content: Text('🎓 Modo Exposición Activado. Todas las funciones listas para demostración.'),
        duration: Duration(seconds: 3),
      ),
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => HomeScreen(apiService: widget.apiService)),
    );
  }

  void _showServerConfigDialog() {
    final urlController = TextEditingController(text: widget.apiService.currentBaseUrl);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Row(
          children: [
            Icon(Icons.dns_rounded, color: AppColors.primaryBlue),
            SizedBox(width: 8),
            Text('Configurar Servidor', style: TextStyle(fontSize: 18, color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ingrese la IP de su laptop o túnel ngrok para conectar en tiempo real:',
              style: TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: urlController,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: const InputDecoration(
                hintText: 'http://192.168.1.50:8080/api/v1',
                labelText: 'URL Base de la API',
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Por defecto en teléfono real sin PC, el sistema opera automáticamente en Modo Demostración.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 11, fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar', style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () async {
              await widget.apiService.setCustomBaseUrl(urlController.text.trim());
              if (!mounted) return;
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Servidor configurado: ${widget.apiService.currentBaseUrl}')),
              );
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Configurar Servidor / IP',
            icon: const Icon(Icons.settings_outlined, color: AppColors.textMuted),
            onPressed: _showServerConfigDialog,
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 12.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo Oficial RED AYUDA
                  Center(
                    child: Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.emergencyRed.withOpacity(0.35),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(48),
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.emergencyRed.withOpacity(0.15),
                              border: Border.all(color: AppColors.emergencyRed, width: 2),
                            ),
                            child: const Icon(Icons.health_and_safety_rounded, color: AppColors.emergencyRed, size: 48),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'RED AYUDA',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '“Una población organizada, una ciudad más segura”',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Selector rápido de perfiles para exposición
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ActionChip(
                        avatar: const Icon(Icons.person_pin_rounded, size: 16, color: AppColors.emergencyRed),
                        label: const Text('Víctima', style: TextStyle(fontSize: 11)),
                        backgroundColor: const Color(0xFF1E293B),
                        onPressed: () {
                          setState(() {
                            _emailController.text = 'victima@redayuda.pe';
                            _passwordController.text = 'Admin123456!';
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      ActionChip(
                        avatar: const Icon(Icons.admin_panel_settings_rounded, size: 16, color: AppColors.primaryBlue),
                        label: const Text('Admin', style: TextStyle(fontSize: 11)),
                        backgroundColor: const Color(0xFF1E293B),
                        onPressed: () {
                          setState(() {
                            _emailController.text = 'admin@redayuda.pe';
                            _passwordController.text = 'Admin123456!';
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      ActionChip(
                        avatar: const Icon(Icons.family_restroom_rounded, size: 16, color: AppColors.successGreen),
                        label: const Text('Contacto', style: TextStyle(fontSize: 11)),
                        backgroundColor: const Color(0xFF1E293B),
                        onPressed: () {
                          setState(() {
                            _emailController.text = 'contacto@redayuda.pe';
                            _passwordController.text = 'Admin123456!';
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Correo Electrónico',
                      prefixIcon: Icon(Icons.email_outlined, color: AppColors.textMuted),
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Ingrese su correo' : null,
                  ),
                  const SizedBox(height: 14),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: Icon(Icons.lock_outline_rounded, color: AppColors.textMuted),
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Ingrese su contraseña' : null,
                  ),
                  const SizedBox(height: 22),

                  // Botón Iniciar Sesión Principal
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: AppColors.primaryBlue,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                          )
                        : const Text(
                            'INICIAR SESIÓN',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 1),
                          ),
                  ),
                  const SizedBox(height: 12),

                  // Botón Rápido Especial para Exposición en Vivo
                  OutlinedButton.icon(
                    icon: const Icon(Icons.school_rounded, color: Color(0xFF38BDF8), size: 18),
                    label: const Text(
                      'MODO EXPOSICIÓN (ACCESO DIRECTO)',
                      style: TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF0284C7), width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      backgroundColor: const Color(0xFF0C4A6E).withOpacity(0.25),
                    ),
                    onPressed: _isLoading ? null : _enterQuickDemo,
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('¿No tiene cuenta? ', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => RegisterScreen(apiService: widget.apiService)),
                          );
                        },
                        child: const Text(
                          'Regístrese aquí',
                          style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
