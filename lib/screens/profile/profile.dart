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
import 'package:convivezen/screens/auth/login_options.dart';

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
        automaticallyImplyLeading: false,
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
                            user?.displayName ??
                                appState.userProfile?.name ??
                                "Usuario",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.pink[800],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.email ?? "email@ejemplo.com",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
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
                              "Configuración completada",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.pink[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Sección 2: Herramientas de bienestar
            Text(
              "Herramientas de Bienestar",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.pink[800],
              ),
            ),

            const SizedBox(height: 12),

            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: [
                    _buildToolCard(
                      title: "Mis Contactos",
                      icon: Icons.contact_phone,
                      color: Colors.blue,
                      onTap: () {
                        // Navegar a contactos de emergencia
                      },
                    ),
                    _buildToolCard(
                      title: "Respiración",
                      icon: Icons.air,
                      color: Colors.green,
                      onTap: () {
                        // Navegar a ejercicios de respiración
                      },
                    ),
                    _buildToolCard(
                      title: "Mindfulness",
                      icon: Icons.self_improvement,
                      color: Colors.purple,
                      onTap: () {
                        // Navegar a mindfulness
                      },
                    ),
                    _buildToolCard(
                      title: "Mi Música",
                      icon: Icons.music_note,
                      color: Colors.orange,
                      onTap: () {
                        // Navegar a música relajante
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Sección 3: Configuración
            Text(
              "Configuración",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.pink[800],
              ),
            ),

            const SizedBox(height: 12),

            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  // Notificaciones
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.notifications,
                        color: Colors.blue[700],
                      ),
                    ),
                    title: Text(
                      "Notificaciones",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      "Recordatorios y alertas",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {
                        // Manejar cambio de notificaciones
                      },
                      activeColor: Colors.pink[400],
                    ),
                  ),
                  Divider(height: 1),

                  // Privacidad
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.privacy_tip,
                        color: Colors.green[700],
                      ),
                    ),
                    title: Text(
                      "Privacidad",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      "Configuración de datos",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navegar a configuración de privacidad
                    },
                  ),
                ],
              ),
            ),

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
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => LoginOptions()),
                                  (_) => false,
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
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => LoginOptions()),
                                      (_) => false,
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

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

Widget _buildToolCard({
  required String title,
  required IconData icon,
  required Color color,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    ),
  );
}
