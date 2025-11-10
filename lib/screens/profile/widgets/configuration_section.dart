import 'package:flutter/material.dart';
import '../widgets/profile_option_tile.dart';
import '../widgets/profile_switch_tile.dart';
import '../../contacts/emergency_contacts_screen.dart';

class ConfigurationSection extends StatelessWidget {
  final Function() onNavigateToProfileSettings;

  const ConfigurationSection({
    Key? key,
    required this.onNavigateToProfileSettings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ProfileOptionTile(
              title: "Mi Cuenta y Privacidad",
              subtitle: "Datos personales, contraseña y privacidad",
              icon: Icons.account_circle,
              color: Colors.pink,
              onTap: onNavigateToProfileSettings,
              trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ),
            const Divider(height: 1),
            ProfileOptionTile(
              title: "Contactos de Emergencia",
              subtitle: "Gestionar personas de confianza",
              icon: Icons.contact_phone,
              color: Colors.red,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmergencyContactsScreen(isEmergencyMode: false),
                  ),
                );
              },
              trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ),
            const Divider(height: 1),
            ProfileSwitchTile(
              title: "Alertas de Bienestar",
              subtitle: "Recordatorios para cuidar tu salud mental",
              icon: Icons.notifications_active,
              color: Colors.amber,
              value: true, // TODO: Implementar estado de notificaciones
              onChanged: (value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Configuración de alertas próximamente')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}