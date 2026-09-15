import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/api_service.dart';
import 'login_screen.dart';
import 'history_screen.dart';

class ProfileScreen extends StatelessWidget {
  final ApiService apiService;

  const ProfileScreen({super.key, required this.apiService});

  @override
  Widget build(BuildContext context) {
    final user = apiService.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Mi Perfil y Ajustes')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.emergencyRed.withOpacity(0.2),
              foregroundColor: AppColors.emergencyRed,
              child: const Icon(Icons.person_rounded, size: 45),
            ),
            const SizedBox(height: 14),
            Text(
              user?.nombreCompleto ?? 'Ciudadano Protegido',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              user?.email ?? 'usuario@redayuda.pe',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 24),

            // Opciones de Configuración
            _buildSettingOption(
              icon: Icons.lock_outline_rounded,
              title: 'Configurar PIN Normal y de Coacción',
              subtitle: 'Defina su PIN de 4 dígitos para cancelación y protección ante agresión',
              onTap: () => _showPinSetupDialog(context),
            ),
            _buildSettingOption(
              icon: Icons.history_rounded,
              title: 'Historial de Emergencias',
              subtitle: 'Consulte reportes, mapas y tiempos de respuesta pasados',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => HistoryScreen(apiService: apiService)),
                );
              },
            ),
            _buildSettingOption(
              icon: Icons.security_rounded,
              title: 'Permisos del Sistema',
              subtitle: 'Verifique acceso a GPS en segundo plano, micrófono y alertas',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Permisos de GPS, Micrófono y Notificaciones activos')),
                );
              },
            ),
            _buildSettingOption(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacidad y Minimización de Datos',
              subtitle: 'Consulte cómo RED AYUDA protege su DNI y grabaciones de audio',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Política de retención: 24 horas para incidentes')),
                );
              },
            ),
            const SizedBox(height: 24),

            // Botón de Cerrar Sesión
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.emergencyRed,
                  side: const BorderSide(color: AppColors.border),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () async {
                  await apiService.logout();
                  if (!context.mounted) return;
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => LoginScreen(apiService: apiService)),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout_rounded),
                label: const Text('CERRAR SESIÓN'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPinSetupDialog(BuildContext context) {
    final pinController = TextEditingController();
    final coercionController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Configurar PIN de Seguridad'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Por su seguridad, el PIN normal y el PIN de coacción deben ser estrictamente diferentes.',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: pinController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'PIN Normal (Ej. 1234)'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: coercionController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'PIN de Coacción (Ej. 9999)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('CANCELAR', style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (pinController.text.length == 4 && coercionController.text.length == 4) {
                if (pinController.text == coercionController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Los dos PIN deben ser diferentes.')),
                  );
                  return;
                }
                final ok = await apiService.setupPin(pinController.text, coercionController.text);
                if (ctx.mounted) Navigator.of(ctx).pop();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(ok ? 'PIN configurado correctamente' : 'Error al configurar PIN')),
                  );
                }
              }
            },
            child: const Text('GUARDAR'),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surfaceLight,
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
        trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
        onTap: onTap,
      ),
    );
  }
}
