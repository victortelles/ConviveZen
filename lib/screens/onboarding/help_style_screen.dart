import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/onboarding_state.dart';
import '../../widgets/onboarding_scaffold.dart';
import '../../providers/app_state.dart';
import '../../models/user_preferences.dart';

class HelpStyleScreen extends StatefulWidget {
  const HelpStyleScreen({Key? key}) : super(key: key);

  @override
  _HelpStyleScreenState createState() => _HelpStyleScreenState();
}

// Pantalla para seleccionar el estilo de ayuda preferido durante el onboarding
class _HelpStyleScreenState extends State<HelpStyleScreen> {
  final List<Map<String, dynamic>> _helpStyles = [
    {
      'key': 'guided',
      'title': 'Guiado paso a paso',
      'description': 'Prefiero instrucciones claras y detalladas que me guíen en cada momento',
      'icon': Icons.assistant_direction,
    },
    {
      'key': 'independent',
      'title': 'Exploración libre',
      'description': 'Me gusta explorar las herramientas por mi cuenta y decidir qué usar',
      'icon': Icons.explore,
    },
    {
      'key': 'quick',
      'title': 'Soluciones rápidas',
      'description': 'Quiero acceso inmediato a técnicas efectivas sin mucha preparación',
      'icon': Icons.flash_on,
    },
    {
      'key': 'deep',
      'title': 'Trabajo profundo',
      'description': 'Prefiero sesiones más largas y técnicas que trabajen las causas profundas',
      'icon': Icons.psychology,
    },
    {
      'key': 'social',
      'title': 'Apoyo social',
      'description': 'Me ayuda conectar con otros y compartir experiencias similares',
      'icon': Icons.people_alt,
    },
    {
      'key': 'private',
      'title': 'Privado y personal',
      'description': 'Prefiero trabajar en mi ansiedad de forma completamente privada',
      'icon': Icons.privacy_tip,
    },
  ];

  // Método para actualizar el estilo de ayuda seleccionado en el estado del onboarding
  void _selectHelpStyle(String styleKey) {
    final onboardingState = Provider.of<OnboardingState>(context, listen: false);
    onboardingState.setHelpStyle(styleKey);
    // Don't auto-navigate, just update the state
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OnboardingState>(
      builder: (context, onboardingState, _) {
        return OnboardingScaffold(
          // Titulo
          title: '¿Cómo prefieres recibir ayuda?',
          // Subtitulo
          subtitle: 'Esto nos permite adaptar la experiencia a tu estilo de aprendizaje',
          // Texto del botón
          buttonText: onboardingState.helpStyle != null 
            ? '¡Completar configuración!' 
            : 'Selecciona una opción',
          isValid: onboardingState.helpStyle != null,
          onContinue: () async {
            // Completar onboarding cuando se presiona el botón
            final appState = Provider.of<AppState>(context, listen: false);
            final currentUserProfile = appState.userProfile!;

            // Actualizar datos del usuario utilizando copyWith para preservar datos existentes
            final updatedUser = currentUserProfile.copyWith(
              isFirstTime: false, // marcar cuando el onboarding lo completo
            );

            // crear el objeto UserPreferences con todos los datos del onboarding
            final preferences = UserPreferences(
              anxietyTypes: onboardingState.anxietyTypes,
              triggers: onboardingState.triggers,
              personalityType: onboardingState.personalityType!,
              hobbies: onboardingState.hobbies,
              musicGenres: onboardingState.musicGenres,
              gameTypes: ['puzzle', 'relaxing'],
              personalAffirmations: [],
              favoriteQuotes: [],
              preferredTone: 'calming',
              favoriteTools: ['breathing', 'meditation', 'music', 'games', 'chat', 'contacts'],
              primaryTool: 'breathing',
              enableAIChat: true,
              autoContactEmergency: false,
              helpStyle: onboardingState.helpStyle!,
              preferVisual: true,
              preferAudio: true,
              enableNotifications: false,
              sessionDuration: 10,
              lastUpdated: DateTime.now(),
              isOnboardingComplete: true,
            );

            try {
              await appState.saveUserToFirestore(updatedUser);
              await appState.saveUserPreferencesToFirestore(preferences);
              Navigator.of(context).pushReplacementNamed('/home');
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error al guardar datos: $e')),
              );
            }
          },
          child: ListView.builder(
            itemCount: _helpStyles.length,
            itemBuilder: (context, index) {
              final style = _helpStyles[index];
              final isSelected = onboardingState.helpStyle == style['key'];

              return OnboardingListItem(
                icon: style['icon'],
                title: style['title'],
                description: style['description'],
                isSelected: isSelected,
                onTap: () => _selectHelpStyle(style['key']),
              );
            },
          ),
        );
      },
    );
  }
}