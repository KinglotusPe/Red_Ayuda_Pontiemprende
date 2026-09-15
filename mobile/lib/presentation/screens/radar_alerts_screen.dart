import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/api_service.dart';
import '../../models/nearby_alert_model.dart';

class RadarAlertsScreen extends StatefulWidget {
  final ApiService apiService;

  const RadarAlertsScreen({super.key, required this.apiService});

  @override
  State<RadarAlertsScreen> createState() => _RadarAlertsScreenState();
}

class _RadarAlertsScreenState extends State<RadarAlertsScreen> {
  List<NearbyAlertModel> _alerts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRadarAlerts();
  }

  Future<void> _loadRadarAlerts() async {
    setState(() => _isLoading = true);
    // Coordenadas Ayacucho Centro
    final alerts = await widget.apiService.getNearbyAlerts(-13.1631, -74.2236);
    setState(() {
      _alerts = alerts;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Radar Ciudadano'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loadRadarAlerts,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            color: AppColors.surface,
            child: const Row(
              children: [
                Icon(Icons.privacy_tip_outlined, color: AppColors.infoBlue, size: 18),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Privacidad estricta: No se revelan nombres, audios ni coordenadas exactas.',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.emergencyRed))
                : _alerts.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.radar_rounded, color: AppColors.successGreen.withOpacity(0.4), size: 65),
                            const SizedBox(height: 16),
                            const Text(
                              'Zona Segura',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'No se registran alertas de emergencia activas en su perímetro cercano.',
                              style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _alerts.length,
                        itemBuilder: (context, index) {
                          final alert = _alerts[index];
                          return _buildAlertCard(alert);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard(NearbyAlertModel alert) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.emergencyRed.withOpacity(0.5)),
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
                  color: AppColors.emergencyRed.withOpacity(0.2),
                ),
                child: const Icon(Icons.warning_rounded, color: AppColors.emergencyRed, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EMERGENCIA CERCA: ${alert.tipo.replaceAll('_', ' ')}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Aprox. a ${alert.distanciaAproximadaMetros.toStringAsFixed(0)} metros • ${alert.zonaAproximada}',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.infoBlue,
                  side: const BorderSide(color: AppColors.infoBlue),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Visualizando zona aproximada de la alerta')),
                  );
                },
                icon: const Icon(Icons.map_rounded, size: 14),
                label: const Text('VER ZONA', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.emergencyRed,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Llamando a Policía 105 para reportar auxilio')),
                  );
                },
                icon: const Icon(Icons.call_rounded, size: 14),
                label: const Text('DAR AVISO (105)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
