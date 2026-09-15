import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/api_service.dart';
import '../../core/services/emergency_state.dart';
import '../../models/contact_model.dart';
import 'add_edit_contact_screen.dart';

class ContactsScreen extends StatelessWidget {
  final ApiService apiService;

  const ContactsScreen({super.key, required this.apiService});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EmergencyState>();
    final contacts = state.contacts;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Contactos de Confianza'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => state.refreshContacts(),
          ),
        ],
      ),
      body: contacts.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.people_outline_rounded, color: AppColors.textMuted, size: 60),
                    const SizedBox(height: 16),
                    const Text(
                      'No tiene contactos de emergencia registrados',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Registre hasta 5 personas de confianza (familiares, amigos) que recibirán su ubicación y alerta SOS inmediata.',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => _navigateToAdd(context),
                      icon: const Icon(Icons.person_add_alt_1_rounded),
                      label: const Text('AGREGAR CONTACTO'),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final c = contacts[index];
                return _buildContactCard(context, c, state);
              },
            ),
      floatingActionButton: contacts.length < 5
          ? FloatingActionButton.extended(
              backgroundColor: AppColors.emergencyRed,
              onPressed: () => _navigateToAdd(context),
              icon: const Icon(Icons.add_rounded, color: Colors.white),
              label: Text(
                'Agregar (${contacts.length}/5)',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )
          : null,
    );
  }

  void _navigateToAdd(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AddEditContactScreen(apiService: apiService)),
    );
  }

  Widget _buildContactCard(BuildContext context, ContactModel contact, EmergencyState state) {
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
          CircleAvatar(
            backgroundColor: AppColors.infoBlue.withOpacity(0.2),
            foregroundColor: AppColors.infoBlue,
            radius: 24,
            child: Text(
              contact.nombre.isNotEmpty ? contact.nombre[0].toUpperCase() : 'C',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      contact.nombre,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    if (contact.tieneRedAyuda) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.successGreen.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'RED AYUDA APP',
                          style: TextStyle(color: AppColors.successGreen, fontSize: 9, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${contact.parentesco ?? "Contacto"} • ${contact.telefono}',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  'Prioridad ${contact.prioridad} • ${contact.permiteAudio ? "Audio autoriz." : "Sin audio"}',
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.emergencyRed, size: 22),
            onPressed: () async {
              await apiService.deleteContact(contact.id);
              await state.refreshContacts();
            },
          ),
        ],
      ),
    );
  }
}
