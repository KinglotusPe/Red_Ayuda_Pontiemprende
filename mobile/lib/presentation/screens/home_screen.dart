import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/api_service.dart';
import '../../core/services/emergency_state.dart';
import '../widgets/sos_button.dart';
import '../widgets/protection_status_card.dart';
import '../widgets/bottom_nav_bar.dart';
import 'countdown_screen.dart';
import 'contacts_screen.dart';
import 'directory_screen.dart';
import 'radar_alerts_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final ApiService apiService;

  const HomeScreen({super.key, required this.apiService});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmergencyState>().loadInitialData();
    });
  }

  void _onSosTriggered() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CountdownScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHomeDashboard(),
      RadarAlertsScreen(apiService: widget.apiService),
      ContactsScreen(apiService: widget.apiService),
      DirectoryScreen(apiService: widget.apiService),
      ProfileScreen(apiService: widget.apiService),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _currentIndex == 0
          ? AppBar(
              title: const Text('RED AYUDA', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5)),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_none_rounded),
                  onPressed: () {
                    setState(() => _currentIndex = 1); // Ir a Radar
                  },
                ),
              ],
            )
          : null,
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: RedAyudaBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }

  Widget _buildHomeDashboard() {
    final state = context.watch<EmergencyState>();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        children: [
          const ProtectionStatusCard(),
          const SizedBox(height: 24),

          // Selector rápido de tipo de emergencia
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'TIPO DE ALERTA RÁPIDA',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildTypeChip('ROBO', Icons.security_rounded, state),
                    _buildTypeChip('AGRESION', Icons.shield_rounded, state),
                    _buildTypeChip('ACOSO', Icons.person_search_rounded, state),
                    _buildTypeChip('ACCIDENTE', Icons.car_crash_rounded, state),
                    _buildTypeChip('EMERGENCIA_MEDICA', Icons.medical_services_rounded, state),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),

          // Botón SOS Central (Mantener presionado 3 segundos)
          SosButton(onTriggered: _onSosTriggered),
          const SizedBox(height: 30),

          // Acceso rápido a Central 105 y SAMU 106
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildQuickCallButton('Policía 105', Icons.local_police_rounded, AppColors.infoBlue),
                const SizedBox(
                  height: 35,
                  child: VerticalDivider(color: AppColors.border, width: 1),
                ),
                _buildQuickCallButton('SAMU 106', Icons.local_hospital_rounded, AppColors.emergencyRed),
                const SizedBox(
                  height: 35,
                  child: VerticalDivider(color: AppColors.border, width: 1),
                ),
                _buildQuickCallButton('Bomberos 116', Icons.fire_truck_rounded, AppColors.warningOrange),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeChip(String type, IconData icon, EmergencyState state) {
    final isSelected = state.selectedEmergencyType == type;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        avatar: Icon(icon, size: 16, color: isSelected ? Colors.white : AppColors.textSecondary),
        label: Text(
          type.replaceAll('_', ' '),
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.emergencyRed,
        checkmarkColor: Colors.white,
        side: BorderSide(color: isSelected ? AppColors.emergencyRed : AppColors.border),
        onSelected: (_) {
          state.setSelectedEmergencyType(type);
        },
      ),
    );
  }

  Widget _buildQuickCallButton(String label, IconData icon, Color color) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Marcando $label...')),
        );
      },
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
