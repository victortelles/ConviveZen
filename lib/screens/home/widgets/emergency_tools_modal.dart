import 'package:flutter/material.dart';
import 'emergency_tool_button.dart';

class EmergencyToolsModal extends StatelessWidget {
  final VoidCallback onBreathingExercise;
  final VoidCallback onMeditation;
  final VoidCallback onMusic;
  final VoidCallback onGames;
  final VoidCallback onAIChat;
  final VoidCallback onEmergencyContacts;
  final VoidCallback? onFeelBetter; // Ahora opcional
  final Function(String) onShowPremiumDialog;

  const EmergencyToolsModal({
    Key? key,
    required this.onBreathingExercise,
    required this.onMeditation,
    required this.onMusic,
    required this.onGames,
    required this.onAIChat,
    required this.onEmergencyContacts,
    this.onFeelBetter, // Opcional
    required this.onShowPremiumDialog,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  EmergencyToolButton(
                    title: 'Respiración Guiada',
                    subtitle: 'Calma inmediata',
                    icon: Icons.air,
                    color: Colors.blue.shade300,
                    isPremium: false,
                    onTap: onBreathingExercise,
                  ),
                  EmergencyToolButton(
                    title: 'Meditación Rápida',
                    subtitle: '3-5 minutos',
                    icon: Icons.self_improvement,
                    color: Colors.purple.shade300,
                    isPremium: true,
                    onTap: () {
                      Navigator.pop(context);
                      onShowPremiumDialog('Meditación Rápida');
                    },
                  ),
                  EmergencyToolButton(
                    title: 'Música Relajante',
                    subtitle: 'Tu playlist personalizada',
                    icon: Icons.music_note,
                    color: Colors.green.shade300,
                    isPremium: false,
                    onTap: onMusic,
                  ),
                  EmergencyToolButton(
                    title: 'Juegos Calmantes',
                    subtitle: 'Distrae tu mente',
                    icon: Icons.games,
                    color: Colors.orange.shade300,
                    isPremium: true,
                    onTap: () {
                      Navigator.pop(context);
                      onShowPremiumDialog('Juegos Calmantes');
                    },
                  ),
                  EmergencyToolButton(
                    title: 'Chat de Apoyo',
                    subtitle: 'IA compasiva',
                    icon: Icons.chat_bubble_outline,
                    color: Colors.cyan.shade300,
                    isPremium: true,
                    onTap: () {
                      Navigator.pop(context);
                      onShowPremiumDialog('Chat de Apoyo');
                    },
                  ),
                  EmergencyToolButton(
                    title: 'Contactos de Emergencia',
                    subtitle: 'Llama a alguien de confianza',
                    icon: Icons.phone,
                    color: Colors.red.shade300,
                    isPremium: false,
                    onTap: onEmergencyContacts,
                  ),
                ],
              ),
            ),
          ),
          // Botón "Me siento mejor" solo si se proporciona el callback
          if (onFeelBetter != null)
            Padding(
              padding: EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: onFeelBetter,
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
    );
  }
}