import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/onboarding_state.dart';
import '../../widgets/onboarding_scaffold.dart';

class TriggersScreen extends StatefulWidget {
  const TriggersScreen({Key? key}) : super(key: key);

  @override
  _TriggersScreenState createState() => _TriggersScreenState();
}

class _TriggersScreenState extends State<TriggersScreen> {
  final List<Map<String, dynamic>> _triggers = [
    {'key': 'exams', 'title': 'Exámenes/Evaluaciones', 'description': 'Pruebas académicas y evaluaciones', 'icon': Icons.assignment},
    {'key': 'social_situations', 'title': 'Situaciones sociales', 'description': 'Interacciones con otras personas', 'icon': Icons.people},
    {'key': 'public_speaking', 'title': 'Hablar en público', 'description': 'Presentaciones y exposiciones', 'icon': Icons.mic},
    {'key': 'deadlines', 'title': 'Fechas límite', 'description': 'Presión por entregas y plazos', 'icon': Icons.schedule},
    {'key': 'crowds', 'title': 'Multitudes', 'description': 'Espacios con muchas personas', 'icon': Icons.groups},
    {'key': 'conflict', 'title': 'Conflictos', 'description': 'Discusiones y confrontaciones', 'icon': Icons.warning},
    {'key': 'family_issues', 'title': 'Problemas familiares', 'description': 'Tensiones en el hogar', 'icon': Icons.home},
    {'key': 'financial_stress', 'title': 'Estrés financiero', 'description': 'Preocupaciones económicas', 'icon': Icons.monetization_on},
    {'key': 'health_concerns', 'title': 'Preocupaciones de salud', 'description': 'Inquietudes sobre bienestar físico', 'icon': Icons.health_and_safety},
    {'key': 'future_uncertainty', 'title': 'Incertidumbre del futuro', 'description': 'Dudas sobre lo que viene', 'icon': Icons.help_outline},
    {'key': 'work_pressure', 'title': 'Presión laboral/académica', 'description': 'Estrés por responsabilidades', 'icon': Icons.work},
    {'key': 'relationships', 'title': 'Relaciones interpersonales', 'description': 'Problemas en vínculos personales', 'icon': Icons.favorite},
    {'key': 'technology', 'title': 'Problemas tecnológicos', 'description': 'Dificultades con dispositivos digitales', 'icon': Icons.devices},
    {'key': 'change', 'title': 'Cambios inesperados', 'description': 'Situaciones imprevistas', 'icon': Icons.sync},
    {'key': 'perfectionism', 'title': 'Perfeccionismo', 'description': 'Autoexigencia excesiva', 'icon': Icons.star},
    {'key': 'loneliness', 'title': 'Soledad', 'description': 'Sentimientos de aislamiento', 'icon': Icons.person_outline},
  ];

  void _toggleTrigger(String triggerKey) {
    final onboardingState = Provider.of<OnboardingState>(context, listen: false);
    List<String> currentTriggers = List.from(onboardingState.triggers);
    
    if (currentTriggers.contains(triggerKey)) {
      currentTriggers.remove(triggerKey);
    } else {
      currentTriggers.add(triggerKey);
    }
    
    onboardingState.setTriggers(currentTriggers);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OnboardingState>(
      builder: (context, onboardingState, _) {
        return OnboardingScaffold(
          title: '¿Qué situaciones suelen generar ansiedad en ti?',
          subtitle: 'Identifica tus triggers para recibir ayuda más personalizada. Puedes seleccionar varias opciones',
          buttonText: 'Continuar',
          isValid: true, // Permitir continuar sin seleccionar (opcional)
          onContinue: () => onboardingState.nextStep(),
          child: Column(
            children: [
              // Selected count
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.pink.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.pink.shade200),
                ),
                child: Text(
                  'Triggers identificados: ${onboardingState.triggers.length}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.pink.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 20),
              
              // Triggers list
              Expanded(
                child: ListView.builder(
                  itemCount: _triggers.length,
                  itemBuilder: (context, index) {
                    final trigger = _triggers[index];
                    final isSelected = onboardingState.triggers.contains(trigger['key']);
                    
                    return OnboardingListItem(
                      icon: trigger['icon'],
                      title: trigger['title'],
                      description: trigger['description'],
                      isSelected: isSelected,
                      onTap: () => _toggleTrigger(trigger['key']),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}