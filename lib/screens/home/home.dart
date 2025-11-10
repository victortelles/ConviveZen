import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../profile/profile.dart';
import '../music/music_screen.dart';
import '../contacts/emergency_contacts_screen.dart';
import '../breathing/breathing_exercise_screen.dart';
import 'widgets/emergency_button.dart';
import 'widgets/emergency_tools_modal.dart';
import 'widgets/home_header.dart';
import 'widgets/premium_feature_dialog.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isEmergencyMode = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _activateEmergencyMode() async {
    setState(() {
      _isEmergencyMode = true;
    });
    _showEmergencyTools();
  }

  void _showEmergencyTools() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EmergencyToolsModal(
        onBreathingExercise: _launchBreathingExercise,
        onMeditation: _launchMeditation,
        onMusic: _launchMusic,
        onGames: _launchGames,
        onAIChat: _launchAIChat,
        onEmergencyContacts: _showEmergencyContacts,
        onFeelBetter: () {
          setState(() {
            _isEmergencyMode = false;
          });
          Navigator.pop(context);
        },
        onShowPremiumDialog: _showPremiumFeatureDialog,
      ),
    );
  }

  void _showPremiumFeatureDialog(String featureName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PremiumFeatureDialog(featureName: featureName);
      },
    );
  }

  void _launchBreathingExercise() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BreathingExerciseScreen(),
      ),
    );
  }

  void _launchMeditation() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Meditación próximamente')),
    );
  }

  void _launchMusic() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MusicScreen(),
      ),
    );
  }

  void _launchGames() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Juegos calmantes próximamente')),
    );
  }

  void _launchAIChat() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Chat de apoyo próximamente')),
    );
  }

  void _showEmergencyContacts() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmergencyContactsScreen(isEmergencyMode: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    // Limitar el nombre de usuario a 16 caracteres y agregar '...'
    String displayName = appState.userProfile?.name ?? 'Usuario';
    if (displayName.length > 16) {
      displayName = displayName.substring(0, 16) + '...';
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.pink.shade50,
              Colors.pink.shade100,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              HomeHeader(
                userName: displayName,
                onProfileTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(),
                    ),
                  );
                },
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!_isEmergencyMode) ...[
                        Text(
                          'Presiona si necesitas ayuda inmediata',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.pink.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 40),
                        EmergencyButton(
                          pulseAnimation: _pulseAnimation,
                          onPressed: _activateEmergencyMode,
                        ),
                        SizedBox(height: 40),
                        Text(
                          'Estamos aquí para ti 24/7',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.pink.shade500,
                          ),
                        ),
                      ] else ...[
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 60,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Herramientas de ayuda activadas',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                        ),
                        Text(
                          'Elige la que más te ayude ahora',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.green.shade600,
                          ),
                        ),
                      ],
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
}