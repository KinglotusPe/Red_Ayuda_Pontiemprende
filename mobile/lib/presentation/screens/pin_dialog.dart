import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class PinDialog extends StatefulWidget {
  final String title;
  final String subtitle;
  final Function(String pin) onPinEntered;

  const PinDialog({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onPinEntered,
  });

  @override
  State<PinDialog> createState() => _PinDialogState();
}

class _PinDialogState extends State<PinDialog> {
  String _pin = '';

  void _addDigit(String digit) {
    if (_pin.length < 4) {
      setState(() {
        _pin += digit;
      });
      if (_pin.length == 4) {
        widget.onPinEntered(_pin);
        Navigator.of(context).pop();
      }
    }
  }

  void _removeDigit() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_outline_rounded, color: AppColors.emergencyRed, size: 40),
            const SizedBox(height: 12),
            Text(
              widget.title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              widget.subtitle,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Indicadores de dígitos
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                final isFilled = index < _pin.length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFilled ? AppColors.emergencyRed : Colors.transparent,
                    border: Border.all(
                      color: isFilled ? AppColors.emergencyRed : AppColors.border,
                      width: 2,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 28),
            // Teclado numérico
            Column(
              children: [
                _buildRow(['1', '2', '3']),
                const SizedBox(height: 12),
                _buildRow(['4', '5', '6']),
                const SizedBox(height: 12),
                _buildRow(['7', '8', '9']),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.textMuted),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    _buildKey('0'),
                    IconButton(
                      icon: const Icon(Icons.backspace_outlined, color: AppColors.textSecondary),
                      onPressed: _removeDigit,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((k) => _buildKey(k)).toList(),
    );
  }

  Widget _buildKey(String key) {
    return InkWell(
      onTap: () => _addDigit(key),
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 60,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surfaceLight.withOpacity(0.5),
        ),
        child: Text(
          key,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
