import 'package:flutter/material.dart';
import '../widgets/profile_option_tile.dart';

class OnboardingCard extends StatelessWidget {
  final Function() onNavigateToAnxietyTypes;
  final Function() onNavigateToMusicPreferences;
  final Function() onNavigateToHobbies;
  final Function() onNavigateToHelpStyle;
  final Function() onNavigateToTriggers;
  final Function() onNavigateToPersonalityType;

  const OnboardingCard({
    Key? key,
    required this.onNavigateToAnxietyTypes,
    required this.onNavigateToMusicPreferences,
    required this.onNavigateToHobbies,
    required this.onNavigateToHelpStyle,
    required this.onNavigateToTriggers,
    required this.onNavigateToPersonalityType,
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
              title: "Mis Tipos de Ansiedad",
              subtitle: "Actualiza qué te genera ansiedad",
              icon: Icons.psychology,
              color: Colors.deepPurple,
              onTap: onNavigateToAnxietyTypes,
            ),
            const Divider(height: 1),
            ProfileOptionTile(
              title: "Música que me Calma",
              subtitle: "Ajusta géneros y artistas relajantes",
              icon: Icons.music_note,
              color: Colors.orange,
              onTap: onNavigateToMusicPreferences,
            ),
            const Divider(height: 1),
            ProfileOptionTile(
              title: "Actividades que me Relajan",
              subtitle: "Personaliza hobbies contra la ansiedad",
              icon: Icons.self_improvement,
              color: Colors.green,
              onTap: onNavigateToHobbies,
            ),
            const Divider(height: 1),
            ProfileOptionTile(
              title: "Cómo Prefiero Recibir Apoyo",
              subtitle: "Configura tu estilo de contención",
              icon: Icons.favorite,
              color: Colors.red,
              onTap: onNavigateToHelpStyle,
            ),
            const Divider(height: 1),
            ProfileOptionTile(
              title: "Mis Triggers",
              subtitle: "Identifica qué situaciones te generan ansiedad",
              icon: Icons.warning,
              color: Colors.yellow.shade600,
              onTap: onNavigateToTriggers,
            ),
            const Divider(height: 1),
            ProfileOptionTile(
              title: "Mi Personalidad",
              subtitle: "Define tu tipo de personalidad",
              icon: Icons.person,
              color: Colors.teal,
              onTap: onNavigateToPersonalityType,
            ),
          ],
        ),
      ),
    );
  }
}