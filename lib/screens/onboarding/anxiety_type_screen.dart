import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/onboarding_state.dart';
import '../../widgets/onboarding_scaffold.dart';

class AnxietyTypeScreen extends StatefulWidget {
  const AnxietyTypeScreen({Key? key}) : super(key: key);

  @override
  _AnxietyTypeScreenState createState() => _AnxietyTypeScreenState();
}

class _AnxietyTypeScreenState extends State<AnxietyTypeScreen> {
  final List<Map<String, dynamic>> _anxietyTypes = [
    {
      'key': 'generalized',
      'title': 'Ansiedad Generalizada',
      'description': 'Preocupación constante por diferentes aspectos de la vida',
      'icon': Icons.psychology,
    },
    {
      'key': 'social',
      'title': 'Ansiedad Social',
      'description': 'Miedo intenso en situaciones sociales o de rendimiento',
      'icon': Icons.people,
    },
    {
      'key': 'panic',
      'title': 'Ataques de Pánico',
      'description': 'Episodios súbitos de miedo intenso con síntomas físicos',
      'icon': Icons.warning,
    },
    {
      'key': 'specific',
      'title': 'Fobias Específicas',
      'description': 'Miedo irracional a objetos o situaciones específicas',
      'icon': Icons.block,
    },
    {
      'key': 'performance',
      'title': 'Ansiedad de Rendimiento',
      'description': 'Nerviosismo al hablar en público o rendir exámenes',
      'icon': Icons.school,
    },
    {
      'key': 'mixed',
      'title': 'Combinación',
      'description': 'Experimento diferentes tipos de ansiedad',
      'icon': Icons.apps,
    },
  ];

  void _toggleAnxietyType(String typeKey) {
    final onboardingState = Provider.of<OnboardingState>(context, listen: false);
    List<String> currentTypes = List.from(onboardingState.anxietyTypes);
    
    if (currentTypes.contains(typeKey)) {
      currentTypes.remove(typeKey);
    } else {
      currentTypes.add(typeKey);
    }
    
    onboardingState.setAnxietyTypes(currentTypes);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OnboardingState>(
      builder: (context, onboardingState, _) {
        return OnboardingScaffold(
          title: '¿Qué tipos de ansiedad experimentas?',
          subtitle: 'Puedes seleccionar varios tipos. Esto nos ayuda a personalizar las herramientas más efectivas para ti',
          buttonText: onboardingState.anxietyTypes.isNotEmpty 
            ? 'Continuar (${onboardingState.anxietyTypes.length} seleccionado${onboardingState.anxietyTypes.length > 1 ? 's' : ''})'
            : 'Selecciona al menos uno',
          isValid: onboardingState.anxietyTypes.isNotEmpty,
          onContinue: () => onboardingState.nextStep(),
          child: ListView.builder(
            itemCount: _anxietyTypes.length,
            itemBuilder: (context, index) {
              final type = _anxietyTypes[index];
              final isSelected = onboardingState.anxietyTypes.contains(type['key']);
              
              return OnboardingListItem(
                icon: type['icon'],
                title: type['title'],
                description: type['description'],
                isSelected: isSelected,
                onTap: () => _toggleAnxietyType(type['key']),
              );
            },
          ),
        );
      },
    );
  }
}