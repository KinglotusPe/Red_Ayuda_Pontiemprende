import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/emergency_state.dart';
import 'pin_dialog.dart';

class ActiveEmergencyScreen extends StatefulWidget {
  const ActiveEmergencyScreen({super.key});

  @override
  State<ActiveEmergencyScreen> createState() => _ActiveEmergencyScreenState();
}

class _ActiveEmergencyScreenState extends State<ActiveEmergencyScreen> {
  int _elapsedSeconds = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _elapsedSeconds++);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _onFinalizarPressed() {
    showDialog(
      context: context,
      builder: (_) => PinDialog(
        title: 'Finalizar Emergencia',
        subtitle: 'Ingrese su PIN de 4 dígitos para confirmar la finalización',
        onPinEntered: (pin) async {
          final state = context.read<EmergencyState>();
          try {
            final cancelled = await state.cancelEmergency(pin);
            if (!mounted) return;
            if (cancelled) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Emergencia finalizada.')),
              );
              Navigator.of(context).pop(); // Vuelve a Home
            }
          } catch (e) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('PIN incorrecto. La emergencia continúa activa.')),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EmergencyState>();
    final emergency = state.activeEmergency;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.emergencyRed,
          title: const Text('EMERGENCIA ACTIVA', style: TextStyle(letterSpacing: 1.5, fontWeight: FontWeight.w900)),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Banner pulsante
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: AppColors.emergencyDarkRed.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.emergencyRed),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.broadcast_on_personal_rounded, color: AppColors.emergencyRed, size: 30),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Alerta SOS: ${emergency?.tipo ?? "ROBO"}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tiempo transcurrido: ${_formatTime(_elapsedSeconds)}',
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Estado de Tracking y Audio
              _buildInfoTile(
                icon: Icons.my_location_rounded,
                iconColor: AppColors.infoBlue,
                title: 'Ubicación Satelital GPS',
                subtitle: 'Lat: -13.1631, Lon: -74.2236 (Precisión ±12m)',
                badge: 'EN VIVO',
              ),
              const SizedBox(height: 12),
              _buildInfoTile(
                icon: Icons.mic_rounded,
                iconColor: AppColors.successGreen,
                title: 'Audio de Entorno (5s)',
                subtitle: 'Audio capturado y asegurado en almacenamiento privado',
                badge: 'ASEGURADO',
              ),
              const SizedBox(height: 12),
              _buildInfoTile(
                icon: Icons.people_alt_rounded,
                iconColor: AppColors.warningOrange,
                title: 'Contactos Notificados',
                subtitle: '${state.contacts.length} contactos recibieron alerta con enlace web seguro',
                badge: 'DESPACHADO',
              ),
              const SizedBox(height: 12),
              _buildInfoTile(
                icon: Icons.local_police_rounded,
                iconColor: Colors.blueAccent,
                title: 'Servicio Recomendado',
                subtitle: 'Policía Nacional del Perú (Central 105)',
                badge: 'OFICIAL',
              ),
              const SizedBox(height: 32),

              // Botones de acción
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.infoBlue,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mapa en tiempo real sincronizado')),
                  );
                },
                icon: const Icon(Icons.map_rounded),
                label: const Text('VER MAPA EN TIEMPO REAL'),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surfaceLight,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Marcador oficial: 105 (Policía Nacional)')),
                  );
                },
                icon: const Icon(Icons.call_rounded, color: AppColors.successGreen),
                label: const Text('LLAMAR A EMERGENCIAS (105)'),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.emergencyRed,
                  side: const BorderSide(color: AppColors.emergencyRed, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: _onFinalizarPressed,
                icon: const Icon(Icons.check_circle_outline_rounded),
                label: const Text(
                  'FINALIZAR EMERGENCIA (CON PIN)',
                  style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String badge,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconColor.withOpacity(0.15),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: iconColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        badge,
                        style: TextStyle(color: iconColor, fontSize: 10, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
