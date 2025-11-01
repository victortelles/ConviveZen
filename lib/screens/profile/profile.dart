import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//Providers
import '../../providers/app_state.dart';
import 'package:provider/provider.dart';

//Widgets
import '../../widgets/profile_avatar.dart';

//Services
import '../../services/profile_image.dart';

//Ventanas


class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileImageService _imageService = ProfileImageService();

  void _showImagePickerModal() async {
    File? pickedImage = await _imageService.pickImage();

    if (pickedImage != null) {
      final user = FirebaseAuth.instance.currentUser;
      final appState = Provider.of<AppState>(context, listen: false);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Confirmar nueva imagen"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: FileImage(pickedImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text("¿Deseas usar esta imagen como tu foto de perfil?"),
              ],
            ),
            actions: [
              TextButton(
                child: Text("Cancelar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text("Aceptar"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  final imageUrl =
                      await _imageService.uploadImage(pickedImage, user!.uid);
                  if (imageUrl != null) {
                    await appState.updateProfileImage(imageUrl);
                    // Mostrar notificación de éxito
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Foto de perfil actualizada")),
                    );
                  } else {
                    // Mostrar notificación de error
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text("Error al actualizar la foto de perfil")),
                    );
                  }
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    var appState = Provider.of<AppState>(context);

    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Mi Perfil",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.pink[400],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección 1: Información del usuario
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _showImagePickerModal,
                      child: ProfileAvatar(
                        imageUrl: appState.userProfile?.profilePic,
                        onImageTap: _showImagePickerModal,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _truncateString(
                              user?.displayName ??
                                  appState.userProfile?.name ??
                                  "Usuario",
                              20,
                            ),
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.pink[800],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _truncateString(
                              user?.email ?? "email@ejemplo.com",
                              25,
                            ),
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.pink[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  "Perfil completo",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.pink[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green[100],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.green.shade300),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      size: 12,
                                      color: Colors.green[700],
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "GRATIS",
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        color: Colors.green[700],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Sección: Personalización
            _buildSectionTitle("Personalización"),
            const SizedBox(height: 12),
            _buildOnboardingCard(),

            const SizedBox(height: 24),

            // Sección: Configuración
            _buildSectionTitle("Configuración"),
            const SizedBox(height: 12),
            _buildConfigurationSection(appState),

            const SizedBox(height: 24),

            // Sección: Suscripción
            _buildSectionTitle("Suscripción"),
            const SizedBox(height: 12),
            _buildSubscriptionCard(),

            const SizedBox(height: 24),

            // Sección 1: Opciones de Onboarding
            _buildSectionTitle("Configurar Onboarding"),
            const SizedBox(height: 12),
            _buildOnboardingCard(),

            const SizedBox(height: 24),

            // Sección 2: Configuración General
            _buildSectionTitle("Configuración"),
            const SizedBox(height: 12),
            _buildConfigurationSection(appState),

            const SizedBox(height: 24),

            // Sección 3: Suscripción
            _buildSectionTitle("Suscripción"),
            const SizedBox(height: 12),
            _buildSubscriptionCard(),

            const SizedBox(height: 24),

            // Sección 4: Acciones de cuenta
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  // Cerrar sesión
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.exit_to_app,
                        color: Colors.orange[700],
                      ),
                    ),
                    title: Text(
                      "Cerrar sesión",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        color: Colors.orange[700],
                      ),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text(
                            'Confirmar cierre de sesión',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600),
                          ),
                          content: Text(
                            '¿Estás seguro de que deseas cerrar sesión?',
                            style: GoogleFonts.poppins(),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                'Cancelar',
                                style: GoogleFonts.poppins(color: Colors.grey),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                await FirebaseAuth.instance.signOut();
                                // Simplemente mostrar snackbar en lugar de navegar
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Sesión cerrada')),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange[400],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'Cerrar sesión',
                                style: GoogleFonts.poppins(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Divider(height: 1),

                  // Eliminar cuenta
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.delete_forever,
                        color: Colors.red[700],
                      ),
                    ),
                    title: Text(
                      "Eliminar cuenta",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        color: Colors.red[700],
                      ),
                    ),
                    onTap: () {
                      TextEditingController confirmationController =
                          TextEditingController();

                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text(
                            'Eliminar cuenta',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Esta acción no se puede deshacer. Escribe 'ELIMINAR' para confirmar.",
                                style: GoogleFonts.poppins(),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: confirmationController,
                                decoration: InputDecoration(
                                  hintText: "Escribe ELIMINAR",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                "Cancelar",
                                style: GoogleFonts.poppins(color: Colors.grey),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (confirmationController.text.trim() ==
                                    "ELIMINAR") {
                                  try {
                                    Navigator.pop(context);
                                    final user =
                                        FirebaseAuth.instance.currentUser;
                                    await user?.delete();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Cuenta eliminada')),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "Error al eliminar la cuenta: ${e.toString()}"),
                                      ),
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          "Texto de confirmación incorrecto"),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[400],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'Eliminar',
                                style: GoogleFonts.poppins(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method para truncar strings
  String _truncateString(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    }
    return '${text.substring(0, maxLength)}...';
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.pink[800],
      ),
    );
  }

  Widget _buildOnboardingCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildOptionTile(
              title: "Tipos de Ansiedad",
              subtitle: "Modifica tus tipos de ansiedad",
              icon: Icons.psychology,
              color: Colors.purple,
              onTap: () => _navigateToAnxietyTypes(),
            ),
            const Divider(height: 1),
            _buildOptionTile(
              title: "Preferencias Musicales",
              subtitle: "Actualiza tus géneros favoritos",
              icon: Icons.music_note,
              color: Colors.orange,
              onTap: () => _navigateToMusicPreferences(),
            ),
            const Divider(height: 1),
            _buildOptionTile(
              title: "Hobbies e Intereses",
              subtitle: "Cambia tus hobbies y actividades",
              icon: Icons.sports_soccer,
              color: Colors.green,
              onTap: () => _navigateToHobbies(),
            ),
            const Divider(height: 1),
            _buildOptionTile(
              title: "Estilo de Ayuda",
              subtitle: "Personaliza cómo recibes apoyo",
              icon: Icons.support_agent,
              color: Colors.blue,
              onTap: () => _navigateToHelpStyle(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigurationSection(AppState appState) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildOptionTile(
              title: "Perfil",
              subtitle: "Contraseña, preferencias, datos personales",
              icon: Icons.person,
              color: Colors.pink,
              onTap: () => _navigateToProfileSettings(),
              trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ),
            const Divider(height: 1),
            _buildSwitchTile(
              title: "Modo Oscuro",
              subtitle: "Cambia el tema de la aplicación",
              icon: Icons.dark_mode,
              color: Colors.indigo,
              value: appState.isDarkMode,
              onChanged: (value) => appState.toggleDarkMode(),
            ),
            const Divider(height: 1),
            _buildSwitchTile(
              title: "Notificaciones",
              subtitle: "Alertas y recordatorios",
              icon: Icons.notifications,
              color: Colors.amber,
              value: true, // TODO: Implementar estado de notificaciones
              onChanged: (value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Configuración de notificaciones próximamente')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildOptionTile(
              title: "Plan Actual: Gratis",
              subtitle: "Toca para ver opciones de suscripción",
              icon: Icons.card_membership,
              color: Colors.green,
              onTap: () => _showSubscriptionOptions(),
              trailing: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'ACTIVO',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.pink[800],
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
      trailing: trailing ?? Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.pink[800],
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.pink[400],
      ),
    );
  }

  // Métodos de navegación
  void _navigateToAnxietyTypes() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Configuración de tipos de ansiedad próximamente')),
    );
  }

  void _navigateToMusicPreferences() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Configuración de música próximamente')),
    );
  }

  void _navigateToHobbies() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Configuración de hobbies próximamente')),
    );
  }

  void _navigateToHelpStyle() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Configuración de estilo de ayuda próximamente')),
    );
  }

  void _navigateToProfileSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Configuración de perfil próximamente')),
    );
  }

  void _showSubscriptionOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Opciones de Suscripción',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.pink.shade700,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildSubscriptionPlanCard('Gratis', 'Plan actual', true),
                    SizedBox(height: 16),
                    _buildSubscriptionPlanCard('Premium', '\$9.99/mes', false),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionPlanCard(String title, String price, bool isActive) {
    bool isPremium = title == 'Premium';
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isPremium ? Colors.orange.shade50 : Colors.green.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isPremium ? Colors.orange.shade300 : Colors.green.shade300,
          width: isActive ? 3 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isPremium ? Colors.orange.shade700 : Colors.green.shade700,
                ),
              ),
              if (isActive)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade600,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'ACTIVO',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            price,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 12),
          if (isPremium) ...[
            _buildFeatureItem('Meditaciones personalizadas'),
            _buildFeatureItem('Chat de IA compasiva 24/7'),
            _buildFeatureItem('Juegos calmantes avanzados'),
            _buildFeatureItem('Análisis detallado de progreso'),
            _buildFeatureItem('Alertas inteligentes'),
          ] else ...[
            _buildFeatureItem('Respiración guiada'),
            _buildFeatureItem('Música relajante básica'),
            _buildFeatureItem('Contactos de emergencia'),
            _buildFeatureItem('Registro de estado emocional'),
          ],
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                if (isPremium && !isActive) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Suscripción Premium próximamente'),
                      backgroundColor: Colors.orange.shade600,
                    ),
                  );
                } else if (isPremium && isActive) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Cancelación de suscripción próximamente'),
                      backgroundColor: Colors.red.shade600,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isPremium 
                    ? (isActive ? Colors.red.shade400 : Colors.orange.shade600)
                    : Colors.green.shade600,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                isPremium 
                    ? (isActive ? 'Cancelar Suscripción' : 'Suscribirse')
                    : 'Plan Actual',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String feature) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(Icons.check, color: Colors.green.shade600, size: 16),
          SizedBox(width: 8),
          Text(
            feature,
            style: GoogleFonts.poppins(fontSize: 13),
          ),
        ],
      ),
    );
  }
}
