import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/emergency_state.dart';

class ProtectionStatusCard extends StatelessWidget {
  const ProtectionStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EmergencyState>();
    final isFull = state.protectionLevel == ProtectionLevel.completa;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isFull ? AppColors.successGreen.withOpacity(0.4) : AppColors.warningOrange.withOpacity(0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (isFull ? AppColors.successGreen : AppColors.warningOrange).withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (isFull ? AppColors.successGreen : AppColors.warningOrange).withOpacity(0.2),
                ),
                child: Icon(
                  isFull ? Icons.shield_rounded : Icons.shield_outlined,
                  color: isFull ? AppColors.successGreen : AppColors.warningOrange,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isFull ? 'PROTECCIÓN COMPLETA' : 'PROTECCIÓN LIMITADA',
                      style: TextStyle(
                        color: isFull ? AppColors.successGreen : AppColors.warningOrange,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isFull
                          ? 'Todos los sistemas de auxilio y rescate están listos'
                          : 'Se recomienda verificar los permisos para máxima seguridad',
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 12),
          // Indicadores de subsistemas
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildIndicator('Ubicación', state.locationEnabled),
              _buildIndicator('Contactos (${state.contacts.length})', state.contacts.isNotEmpty),
              _buildIndicator('Notificaciones', state.notificationsEnabled),
              _buildIndicator('Micrófono', state.microphoneEnabled),
              _buildIndicator('Voz', state.voiceEnabled),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(String label, bool active) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          active ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
          color: active ? AppColors.successGreen : AppColors.textMuted,
          size: 14,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: active ? AppColors.textPrimary : AppColors.textMuted,
            fontSize: 12,
            fontWeight: active ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
