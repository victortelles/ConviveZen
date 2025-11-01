import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../profile/profile.dart';

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
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
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
              'Herramientas de Emergencia',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.pink.shade700,
              ),
            ),
            Text(
              'Estamos aquí para ayudarte 💗',
              style: TextStyle(
                fontSize: 16,
                color: Colors.pink.shade500,
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  children: [
                    _emergencyToolButton(
                      title: 'Respiración Guiada',
                      subtitle: 'Calma inmediata',
                      icon: Icons.air,
                      color: Colors.blue.shade300,
                      onTap: () => _launchBreathingExercise(),
                    ),
                    _emergencyToolButton(
                      title: 'Meditación Rápida',
                      subtitle: '3-5 minutos',
                      icon: Icons.self_improvement,
                      color: Colors.purple.shade300,
                      onTap: () => _launchMeditation(),
                    ),
                    _emergencyToolButton(
                      title: 'Música Relajante',
                      subtitle: 'Tu playlist personalizada',
                      icon: Icons.music_note,
                      color: Colors.green.shade300,
                      onTap: () => _launchMusic(),
                    ),
                    _emergencyToolButton(
                      title: 'Juegos Calmantes',
                      subtitle: 'Distrae tu mente',
                      icon: Icons.games,
                      color: Colors.orange.shade300,
                      onTap: () => _launchGames(),
                    ),
                    _emergencyToolButton(
                      title: 'Chat de Apoyo',
                      subtitle: 'IA compasiva',
                      icon: Icons.chat_bubble_outline,
                      color: Colors.cyan.shade300,
                      onTap: () => _launchAIChat(),
                    ),
                    _emergencyToolButton(
                      title: 'Contactos de Emergencia',
                      subtitle: 'Llama a alguien de confianza',
                      icon: Icons.phone,
                      color: Colors.red.shade300,
                      onTap: () => _showEmergencyContacts(),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isEmergencyMode = false;
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink.shade400,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    'Me siento mejor',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emergencyToolButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.pink.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.pink.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _launchBreathingExercise() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ejercicio de respiración próximamente')),
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Música relajante próximamente')),
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Contactos de emergencia próximamente')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

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
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hola, ${appState.userProfile?.name ?? 'Usuario'}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink.shade700,
                          ),
                        ),
                        Text(
                          '¿Cómo te sientes hoy?',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.pink.shade600,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(),
                          ),
                        );
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.pink.shade200,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
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
                        AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _pulseAnimation.value,
                              child: GestureDetector(
                                onTap: _activateEmergencyMode,
                                child: Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    gradient: RadialGradient(
                                      colors: [
                                        Colors.pink.shade300,
                                        Colors.pink.shade500,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(100),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.pink.shade200,
                                        blurRadius: 20,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.favorite,
                                        color: Colors.white,
                                        size: 60,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'SOS',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Ayuda',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
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
              if (!_isEmergencyMode)
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        'Acceso rápido',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink.shade700,
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _quickAccessButton(
                            'Respirar',
                            Icons.air,
                            Colors.blue.shade300,
                            _launchBreathingExercise,
                          ),
                          _quickAccessButton(
                            'Música',
                            Icons.music_note,
                            Colors.green.shade300,
                            _launchMusic,
                          ),
                          _quickAccessButton(
                            'Meditar',
                            Icons.self_improvement,
                            Colors.purple.shade300,
                            _launchMeditation,
                          ),
                          _quickAccessButton(
                            'Chat',
                            Icons.chat,
                            Colors.cyan.shade300,
                            _launchAIChat,
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
    );
  }

  Widget _quickAccessButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.pink.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}