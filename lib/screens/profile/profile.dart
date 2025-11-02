import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//Providers
import '../../providers/app_state.dart';
import 'package:provider/provider.dart';

//Widgets
import '../../widgets/profile_avatar.dart';
import 'widgets/section_title.dart';
import 'widgets/onboarding_card.dart';
import 'widgets/configuration_section.dart';
import 'widgets/subscription_card.dart';

//Services
import '../../services/profile_image.dart';

//Ventanas
import 'screens/anxiety_types_settings_screen.dart';
import 'screens/music_preferences_settings_screen.dart';
import 'screens/hobbies_settings_screen.dart';
import 'screens/help_style_settings_screen.dart';
import 'screens/triggers_settings_screen.dart';
import 'screens/personality_type_settings_screen.dart';
import '../../models/onboarding_state.dart';


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

            // Sección 1: Personalización de ConviveZen
            SectionTitle(title: "Personalizar mi ConviveZen"),
            const SizedBox(height: 12),
            OnboardingCard(
              onNavigateToAnxietyTypes: _navigateToAnxietyTypes,
              onNavigateToMusicPreferences: _navigateToMusicPreferences,
              onNavigateToHobbies: _navigateToHobbies,
              onNavigateToHelpStyle: _navigateToHelpStyle,
              onNavigateToTriggers: _navigateToTriggers,
              onNavigateToPersonalityType: _navigateToPersonalityType,
            ),

            const SizedBox(height: 24),

            // Sección 2: Configuración de la App
            SectionTitle(title: "Configuración de la App"),
            const SizedBox(height: 12),
            ConfigurationSection(
              onNavigateToProfileSettings: _navigateToProfileSettings,
            ),

            const SizedBox(height: 24),

            // Sección 3: ConviveZen Premium
            SectionTitle(title: "ConviveZen Premium"),
            const SizedBox(height: 12),
            SubscriptionCard(
              onShowSubscriptionOptions: _showSubscriptionOptions,
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

  // Métodos de navegación
  void _navigateToAnxietyTypes() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnxietyTypesSettingsScreen(),
      ),
    );
  }

  // Metodo para navegar a la pantalla de preferencias musicales
  void _navigateToMusicPreferences() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MusicPreferencesSettingsScreen(),
      ),
    );
  }

  // Metodo para navegar a la pantalla de hobbies
  void _navigateToHobbies() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HobbiesSettingsScreen(),
      ),
    );
  }

  // Metodo para navegar a la pantalla de estilo de ayuda
  void _navigateToHelpStyle() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HelpStyleSettingsScreen(),
      ),
    );
  }

  // Metodo para navegar a la pantalla de triggers
  void _navigateToTriggers() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TriggersSettingsScreen(),
      ),
    );
  }

  // Metodo para navegar a la pantalla de tipo de personalidad
  void _navigateToPersonalityType() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonalityTypeSettingsScreen(),
      ),
    );
  }

  // Metodo para navegar a la pantalla de configuracion de perfil
  void _navigateToProfileSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Configuración de perfil próximamente')),
    );
  }

  // Mostrar opciones de suscripción
  void _showSubscriptionOptions() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[850] : Colors.white,
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
                'Planes ConviveZen',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink.shade700,
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _buildSubscriptionPlanCard('Gratis', 'Plan actual', true),
                      SizedBox(height: 16),
                      _buildSubscriptionPlanCard('Premium', '\$9.99/mes', false),
                      SizedBox(height: 20), // Extra padding at bottom
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // CardUp para cada plan de suscripción
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
            _buildFeatureItem('Meditaciones guiadas personalizadas'),
            _buildFeatureItem('Asistente IA especializado en ansiedad'),
            _buildFeatureItem('Ejercicios avanzados de relajación'),
            _buildFeatureItem('Análisis completo de tu bienestar'),
            _buildFeatureItem('Alertas inteligentes de prevención'),
          ] else ...[
            _buildFeatureItem('Botón de pánico inmediato'),
            _buildFeatureItem('Ejercicios básicos de respiración'),
            _buildFeatureItem('Música calmante esencial'),
            _buildFeatureItem('Contactos de confianza'),
            _buildFeatureItem('Registro simple de emociones'),
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

  //
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

// Widget wrapper para usar pantallas de onboarding independientemente
class _OnboardingScreenWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback onSave;

  const _OnboardingScreenWrapper({
    Key? key,
    required this.child,
    required this.onSave,
  }) : super(key: key);

  @override
  _OnboardingScreenWrapperState createState() => _OnboardingScreenWrapperState();
}

class _OnboardingScreenWrapperState extends State<_OnboardingScreenWrapper> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isFirstTime = appState.userProfile?.isFirstTime ?? true;
    
    return Consumer<OnboardingState>(
      builder: (context, onboardingState, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Actualizar Configuración'),
            backgroundColor: Colors.pink.shade50,
            foregroundColor: Colors.pink.shade700,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // Guardar los datos en Firestore
                  widget.onSave();
                },
                child: Text(
                  'Guardar',
                  style: TextStyle(
                    color: Colors.pink.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          body: isFirstTime 
            ? widget.child // Mostrar con barra de progreso para usuarios nuevos
            : _buildStandaloneScreen(context), // Sin barra de progreso para usuarios existentes
        );
      },
    );
  }

  Widget _buildStandaloneScreen(BuildContext context) {
    // Wrapper que elimina las barras de progreso y adapta la pantalla para usuarios existentes
    return Container(
      padding: EdgeInsets.all(16),
      child: widget.child,
    );
  }
}
