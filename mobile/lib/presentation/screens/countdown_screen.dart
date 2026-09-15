import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/emergency_state.dart';
import 'active_emergency_screen.dart';
import 'pin_dialog.dart';

class CountdownScreen extends StatefulWidget {
  const CountdownScreen({super.key});

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  int _remainingSeconds = 10;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 1) {
        setState(() {
          _remainingSeconds--;
        });
        HapticFeedback.lightImpact();
      } else {
        timer.cancel();
        _onCountdownCompleted();
      }
    });
  }

  Future<void> _onCountdownCompleted() async {
    HapticFeedback.heavyImpact();
    final emergencyState = context.read<EmergencyState>();
    final emergency = await emergencyState.triggerSos();

    if (!mounted) return;

    if (emergency != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ActiveEmergencyScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al enviar la alerta SOS')),
      );
      Navigator.of(context).pop();
    }
  }

  void _onCancelPressed() {
    showDialog(
      context: context,
      builder: (_) => PinDialog(
        title: 'Cancelar Alerta SOS',
        subtitle: 'Ingrese su PIN de seguridad de 4 dígitos',
        onPinEntered: (pin) {
          _countdownTimer?.cancel();
          Navigator.of(context).pop(); // Salir de la pantalla de cuenta regresiva
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Alerta cancelada correctamente')),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFF450A0A), // Fondo de alerta roja intensa
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.white,
                    size: 70,
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'EMERGENCIA DETECTADA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'La alerta y su ubicación se enviarán en:',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 36),
                  // Círculo gigante con segundero
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 6),
                      color: AppColors.emergencyRed,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$_remainingSeconds',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 72,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.emergencyDarkRed,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: _onCancelPressed,
                      icon: const Icon(Icons.cancel_rounded, size: 24),
                      label: const Text(
                        'CANCELAR ALERTA',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Requiere PIN de seguridad para cancelar',
                    style: TextStyle(color: Colors.white60, fontSize: 12),
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
