import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/api_service.dart';
import '../../models/directory_model.dart';

class DirectoryScreen extends StatefulWidget {
  final ApiService apiService;

  const DirectoryScreen({super.key, required this.apiService});

  @override
  State<DirectoryScreen> createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends State<DirectoryScreen> {
  List<DirectoryItemModel> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDirectory();
  }

  Future<void> _loadDirectory() async {
    setState(() => _isLoading = true);
    final list = await widget.apiService.getDirectory();
    setState(() {
      _items = list;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Directorio Oficial de Emergencia'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loadDirectory,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.emergencyRed))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return _buildDirectoryCard(item);
              },
            ),
    );
  }

  Widget _buildDirectoryCard(DirectoryItemModel item) {
    Color iconColor;
    IconData iconData;

    switch (item.tipo.toUpperCase()) {
      case 'POLICIA':
        iconColor = AppColors.infoBlue;
        iconData = Icons.local_police_rounded;
        break;
      case 'SAMU':
      case 'HOSPITAL':
        iconColor = AppColors.emergencyRed;
        iconData = Icons.medical_services_rounded;
        break;
      case 'BOMBEROS':
        iconColor = AppColors.warningOrange;
        iconData = Icons.fire_truck_rounded;
        break;
      case 'SERENAZGO':
        iconColor = AppColors.successGreen;
        iconData = Icons.security_rounded;
        break;
      default:
        iconColor = Colors.purpleAccent;
        iconData = Icons.emergency_rounded;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconColor.withOpacity(0.15),
            ),
            child: Icon(iconData, color: iconColor, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.nombre,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.distrito}, ${item.region} • ${item.tipo}',
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                ),
                const SizedBox(height: 6),
                Text(
                  item.telefono,
                  style: TextStyle(color: iconColor, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: iconColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Abriendo marcador para llamar a ${item.telefono}...')),
              );
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.call_rounded, size: 16),
                SizedBox(width: 4),
                Text('LLAMAR', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
