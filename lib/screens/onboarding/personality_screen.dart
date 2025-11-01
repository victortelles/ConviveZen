import 'package:flutter/material.dart';

class PersonalityScreen extends StatefulWidget {
  final Function(String) onPersonalitySelected;

  const PersonalityScreen({Key? key, required this.onPersonalitySelected}) : super(key: key);

  @override
  _PersonalityScreenState createState() => _PersonalityScreenState();
}

class _PersonalityScreenState extends State<PersonalityScreen> {
  String? _selectedPersonality;

  final List<Map<String, dynamic>> _personalityTypes = [
    {
      'key': 'introvert',
      'title': 'Introvertido/a',
      'description': 'Prefiero actividades tranquilas y tiempo a solas para recargar energías',
      'icon': Icons.book,
      'color': Colors.blue.shade300,
    },
    {
      'key': 'extrovert',
      'title': 'Extrovertido/a',
      'description': 'Me energizo con la interacción social y actividades grupales',
      'icon': Icons.groups,
      'color': Colors.orange.shade300,
    },
    {
      'key': 'ambivert',
      'title': 'Ambivertido/a',
      'description': 'Disfruto tanto del tiempo social como del tiempo a solas, según mi estado de ánimo',
      'icon': Icons.balance,
      'color': Colors.purple.shade300,
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
            '¿Cómo te describes mejor?',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.pink.shade700,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            'Esto nos ayuda a sugerir técnicas de relajación más acordes a tu personalidad',
            style: TextStyle(
              fontSize: 16,
              color: Colors.pink.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
          Expanded(
            child: ListView.builder(
              itemCount: _personalityTypes.length,
              itemBuilder: (context, index) {
                final personality = _personalityTypes[index];
                final isSelected = _selectedPersonality == personality['key'];
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedPersonality = personality['key'];
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.pink.shade100 : Colors.white,
                        border: Border.all(
                          color: isSelected ? Colors.pink.shade400 : Colors.pink.shade200,
                          width: isSelected ? 3 : 1,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pink.shade100,
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.pink.shade400 : personality['color'],
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Icon(
                              personality['icon'],
                              color: Colors.white,
                              size: 36,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            personality['title'],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.pink.shade700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8),
                          Text(
                            personality['description'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.pink.shade600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (isSelected) ...[
                            SizedBox(height: 12),
                            Icon(
                              Icons.check_circle,
                              color: Colors.pink.shade400,
                              size: 28,
                            ),
                          ],
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
              onPressed: _selectedPersonality != null
                  ? () => widget.onPersonalitySelected(_selectedPersonality!)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedPersonality != null ? Colors.pink.shade400 : Colors.grey.shade300,
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