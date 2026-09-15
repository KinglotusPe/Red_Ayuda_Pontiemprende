import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';

class SosButton extends StatefulWidget {
  final VoidCallback onTriggered;

  const SosButton({super.key, required this.onTriggered});

  @override
  State<SosButton> createState() => _SosButtonState();
}

class _SosButtonState extends State<SosButton> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  Timer? _holdTimer;
  double _progress = 0.0;
  static const int _holdDurationSeconds = 3;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _holdTimer?.cancel();
    super.dispose();
  }

  void _onPointerDown() {
    HapticFeedback.heavyImpact();
    setState(() => _progress = 0.0);

    const stepMs = 50;
    final totalSteps = (_holdDurationSeconds * 1000) / stepMs;
    int currentStep = 0;

    _holdTimer = Timer.periodic(const Duration(milliseconds: stepMs), (timer) {
      currentStep++;
      setState(() {
        _progress = currentStep / totalSteps;
      });

      if (currentStep >= totalSteps) {
        timer.cancel();
        HapticFeedback.vibrate();
        widget.onTriggered();
        setState(() => _progress = 0.0);
      }
    });
  }

  void _onPointerUp() {
    _holdTimer?.cancel();
    setState(() => _progress = 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTapDown: (_) => _onPointerDown(),
          onTapUp: (_) => _onPointerUp(),
          onTapCancel: () => _onPointerUp(),
          child: AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              final scale = 1.0 + (_pulseController.value * 0.05);
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Anillo exterior de pulso dinámico
                  Container(
                    width: 220 * scale,
                    height: 220 * scale,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.emergencyRed.withOpacity(0.15 * (1 - _pulseController.value)),
                    ),
                  ),
                  // Barra de progreso circular de 3 segundos
                  SizedBox(
                    width: 190,
                    height: 190,
                    child: CircularProgressIndicator(
                      value: _progress,
                      strokeWidth: 8,
                      backgroundColor: AppColors.surfaceLight,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  // Botón Central Rojo
                  Container(
                    width: 170,
                    height: 170,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const RadialGradient(
                        colors: [AppColors.sosGlow, AppColors.emergencyRed, AppColors.emergencyDarkRed],
                        stops: [0.0, 0.6, 1.0],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.emergencyRed.withOpacity(0.5),
                          blurRadius: 25,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.warning_rounded, color: Colors.white, size: 40),
                          const SizedBox(height: 4),
                          const Text(
                            'SOS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                            ),
                          ),
                          if (_progress > 0)
                            Text(
                              '${((1 - _progress) * 3).toStringAsFixed(1)}s',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'MANTÉN PRESIONADO PARA PEDIR AYUDA',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }
}
