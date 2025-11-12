import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../providers/app_state.dart';
import '../../models/crisis_log.dart';
import '../../services/crisis_log_service.dart';
import '../profile/profile.dart';
import '../music/music_screen.dart';
import '../contacts/emergency_contacts_screen.dart';
import '../breathing/breathing_exercise_screen.dart';
import 'widgets/emergency_button.dart';
import 'widgets/emergency_tools_modal.dart';
import 'widgets/home_header.dart';
import 'widgets/premium_feature_dialog.dart';
import 'widgets/crisis_feedback_dialog.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isEmergencyMode = false;
  CrisisLog? _activeCrisisLog;
  final CrisisLogService _crisisLogService = CrisisLogService();
  List<String> _usedTools = [];

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
      _usedTools = [];
    });
    
    // Crear log de crisis
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final logId = await _crisisLogService.createCrisisLog(
          CrisisLog(
            id: '',
            userId: user.uid,
            anxietyLevelBefore: 7, // Default, se puede mejorar con un diálogo previo
            triggerType: 'unknown',
          ),
        );
        
        final log = await _crisisLogService.getActiveCrisisLog(user.uid);
        setState(() {
          _activeCrisisLog = log;
        });
      } catch (e) {
        print('Error creating crisis log: $e');
      }
    }
    
    _showEmergencyTools();
  }

  void _showEmergencyTools() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false, // No permitir cerrar sin seleccionar
      enableDrag: false, // No permitir arrastrar para cerrar
      builder: (context) => EmergencyToolsModal(
        onBreathingExercise: _launchBreathingExercise,
        onMeditation: _launchMeditation,
        onMusic: _launchMusic,
        onGames: _launchGames,
        onAIChat: _launchAIChat,
        onEmergencyContacts: _showEmergencyContacts,
        onFeelBetter: null, // Removido - se manejará con el diálogo
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
    _trackToolUsage('breathing');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BreathingExerciseScreen(),
      ),
    ).then((_) => _checkIfNeedsMoreHelp());
  }

  void _launchMeditation() {
    Navigator.pop(context);
    _trackToolUsage('meditation');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Meditación próximamente')),
    );
  }

  void _launchMusic() {
    Navigator.pop(context);
    _trackToolUsage('music');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MusicScreen(),
      ),
    ).then((_) => _checkIfNeedsMoreHelp());
  }

  void _launchGames() {
    Navigator.pop(context);
    _trackToolUsage('games');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Juegos calmantes próximamente')),
    );
  }

  void _launchAIChat() {
    Navigator.pop(context);
    _trackToolUsage('ai_chat');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Chat de apoyo próximamente')),
    );
  }

  void _showEmergencyContacts() {
    Navigator.pop(context);
    _trackToolUsage('emergency_contacts');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmergencyContactsScreen(isEmergencyMode: true),
      ),
    ).then((_) => _checkIfNeedsMoreHelp());
  }

  // Registrar uso de herramienta
  void _trackToolUsage(String toolType) {
    if (!_usedTools.contains(toolType)) {
      setState(() {
        _usedTools.add(toolType);
      });
    }
    
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _crisisLogService.addToolToActiveLog(user.uid, toolType);
    }
  }

  // Verificar si el usuario necesita más ayuda después de usar una herramienta
  void _checkIfNeedsMoreHelp() {
    if (!_isEmergencyMode) return;
    
    // Pequeño delay para que el usuario regrese a la pantalla
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted && _isEmergencyMode) {
        _showCrisisFeedbackDialog();
      }
    });
  }

  // Mostrar diálogo de feedback post-herramienta
  void _showCrisisFeedbackDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CrisisFeedbackDialog(
        toolsUsed: _usedTools,
        onFeelBetter: _handleFeelBetter,
        onNeedMoreHelp: _handleNeedMoreHelp,
      ),
    );
  }

  // Usuario se siente mejor - completar crisis log
  Future<void> _handleFeelBetter(int anxietyLevel, String? primaryTool, bool wasHelpful) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && _activeCrisisLog != null) {
      try {
        await _crisisLogService.completeActiveCrisisLog(
          userId: user.uid,
          anxietyLevelAfter: anxietyLevel,
          primaryToolUsed: primaryTool,
          wasHelpful: wasHelpful,
        );
        
        // Mostrar notificación de registro exitoso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Se ha registrado tu ansiedad en tu perfil'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      } catch (e) {
        print('Error completing crisis log: $e');
      }
    }
    
    setState(() {
      _isEmergencyMode = false;
      _activeCrisisLog = null;
      _usedTools = [];
    });
  }

  // Usuario necesita más ayuda - reabrir menú de herramientas
  void _handleNeedMoreHelp() {
    Navigator.pop(context); // Cerrar diálogo de feedback
    _showEmergencyTools(); // Reabrir menú de herramientas
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
                profileImageUrl: appState.userProfile?.profilePic,
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