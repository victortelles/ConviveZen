import 'package:flutter/material.dart';

class AnxietyTypeScreen extends StatefulWidget {
  final Function(String) onAnxietyTypeSelected;

  const AnxietyTypeScreen({Key? key, required this.onAnxietyTypeSelected}) : super(key: key);

  @override
  _AnxietyTypeScreenState createState() => _AnxietyTypeScreenState();
}

class _AnxietyTypeScreenState extends State<AnxietyTypeScreen> {
  String? _selectedType;

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '¿Qué tipo de ansiedad experimentas principalmente?',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.pink.shade700,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            'No te preocupes, esto nos ayuda a personalizar las herramientas más efectivas para ti',
            style: TextStyle(
              fontSize: 16,
              color: Colors.pink.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          Expanded(
            child: ListView.builder(
              itemCount: _anxietyTypes.length,
              itemBuilder: (context, index) {
                final type = _anxietyTypes[index];
                final isSelected = _selectedType == type['key'];
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedType = type['key'];
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
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
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.pink.shade400 : Colors.pink.shade200,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Icon(
                              type['icon'],
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  type['title'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.pink.shade700,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  type['description'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.pink.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: Colors.pink.shade400,
                              size: 24,
                            ),
                        ],
                      ),
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
              onPressed: _selectedType != null
                  ? () => widget.onAnxietyTypeSelected(_selectedType!)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedType != null ? Colors.pink.shade400 : Colors.grey.shade300,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 3,
              ),
              child: Text(
                'Continuar',
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