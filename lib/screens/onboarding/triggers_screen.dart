import 'package:flutter/material.dart';

class TriggersScreen extends StatefulWidget {
  final Function(List<String>) onTriggersSelected;

  const TriggersScreen({Key? key, required this.onTriggersSelected}) : super(key: key);

  @override
  _TriggersScreenState createState() => _TriggersScreenState();
}

class _TriggersScreenState extends State<TriggersScreen> {
  List<String> _selectedTriggers = [];

  final List<Map<String, dynamic>> _triggers = [
    {'key': 'exams', 'title': 'Exámenes/Evaluaciones', 'icon': Icons.assignment},
    {'key': 'social_situations', 'title': 'Situaciones sociales', 'icon': Icons.people},
    {'key': 'public_speaking', 'title': 'Hablar en público', 'icon': Icons.mic},
    {'key': 'deadlines', 'title': 'Fechas límite', 'icon': Icons.schedule},
    {'key': 'crowds', 'title': 'Multitudes', 'icon': Icons.groups},
    {'key': 'conflict', 'title': 'Conflictos', 'icon': Icons.warning},
    {'key': 'family_issues', 'title': 'Problemas familiares', 'icon': Icons.home},
    {'key': 'financial_stress', 'title': 'Estrés financiero', 'icon': Icons.monetization_on},
    {'key': 'health_concerns', 'title': 'Preocupaciones de salud', 'icon': Icons.health_and_safety},
    {'key': 'future_uncertainty', 'title': 'Incertidumbre del futuro', 'icon': Icons.help_outline},
    {'key': 'work_pressure', 'title': 'Presión laboral/académica', 'icon': Icons.work},
    {'key': 'relationships', 'title': 'Relaciones interpersonales', 'icon': Icons.favorite},
    {'key': 'technology', 'title': 'Problemas tecnológicos', 'icon': Icons.devices},
    {'key': 'change', 'title': 'Cambios inesperados', 'icon': Icons.sync},
    {'key': 'perfectionism', 'title': 'Perfeccionismo', 'icon': Icons.star},
    {'key': 'loneliness', 'title': 'Soledad', 'icon': Icons.person_outline},
  ];

  void _toggleTrigger(String triggerKey) {
    setState(() {
      if (_selectedTriggers.contains(triggerKey)) {
        _selectedTriggers.remove(triggerKey);
      } else {
        _selectedTriggers.add(triggerKey);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Text(
            '¿Qué situaciones suelen generar ansiedad en ti?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.pink.shade700,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            'Identifica tus triggers para recibir ayuda más personalizada. Puedes seleccionar varias opciones',
            style: TextStyle(
              fontSize: 16,
              color: Colors.pink.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          Text(
            'Triggers identificados: ${_selectedTriggers.length}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.pink.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.1,
              ),
              itemCount: _triggers.length,
              itemBuilder: (context, index) {
                final trigger = _triggers[index];
                final isSelected = _selectedTriggers.contains(trigger['key']);
                
                return GestureDetector(
                  onTap: () => _toggleTrigger(trigger['key']),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.pink.shade100 : Colors.white,
                      border: Border.all(
                        color: isSelected ? Colors.pink.shade400 : Colors.pink.shade200,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pink.shade100,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.pink.shade400 : Colors.pink.shade200,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            trigger['icon'],
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          trigger['title'],
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.pink.shade700,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (isSelected) ...[
                          SizedBox(height: 4),
                          Icon(
                            Icons.check_circle,
                            color: Colors.pink.shade400,
                            size: 14,
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () => widget.onTriggersSelected(_selectedTriggers),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink.shade400,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 3,
              ),
              child: Text(
                _selectedTriggers.isEmpty ? 'Omitir' : 'Continuar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}