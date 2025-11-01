import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/onboarding_state.dart';
import '../../widgets/onboarding_scaffold.dart';

class PersonalityScreen extends StatefulWidget {
  const PersonalityScreen({Key? key}) : super(key: key);

  @override
  _PersonalityScreenState createState() => _PersonalityScreenState();
}

class _PersonalityScreenState extends State<PersonalityScreen> {
  final List<Map<String, dynamic>> _personalityTypes = [
    {
      'key': 'introvert',
      'title': 'Introvertido/a',
      'description': 'Prefiero actividades tranquilas y tiempo a solas para recargar energías',
      'icon': Icons.book,
    },
    {
      'key': 'extrovert',
      'title': 'Extrovertido/a',
      'description': 'Me energizo con la interacción social y actividades grupales',
      'icon': Icons.groups,
    },
    {
      'key': 'ambivert',
      'title': 'Ambivertido/a',
      'description': 'Disfruto tanto del tiempo social como del tiempo a solas, según mi estado de ánimo',
      'icon': Icons.balance,
    },
  ];

  void _selectPersonality(String personalityKey) {
    final onboardingState = Provider.of<OnboardingState>(context, listen: false);
    onboardingState.setPersonalityType(personalityKey);
    // Don't auto-navigate, just update the state
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OnboardingState>(
      builder: (context, onboardingState, _) {
        return OnboardingScaffold(
          title: '¿Cómo te describes mejor?',
          subtitle: 'Esto nos ayuda a personalizar las herramientas según tu estilo de vida',
          buttonText: onboardingState.personalityType != null 
            ? 'Continuar' 
            : 'Selecciona una opción',
          isValid: onboardingState.personalityType != null,
          onContinue: () => onboardingState.nextStep(),
          child: ListView.builder(
            itemCount: _personalityTypes.length,
            itemBuilder: (context, index) {
              final type = _personalityTypes[index];
              final isSelected = onboardingState.personalityType == type['key'];
              
              return OnboardingListItem(
                icon: type['icon'],
                title: type['title'],
                description: type['description'],
                isSelected: isSelected,
                onTap: () => _selectPersonality(type['key']),
              );
            },
          ),
        );
      },
    );
  }
}