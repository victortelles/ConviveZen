import 'package:flutter/material.dart';

class HelpStyleScreen extends StatefulWidget {
  final Function(String) onHelpStyleSelected;

  const HelpStyleScreen({Key? key, required this.onHelpStyleSelected}) : super(key: key);

  @override
  _HelpStyleScreenState createState() => _HelpStyleScreenState();
}

class _HelpStyleScreenState extends State<HelpStyleScreen> {
  String? _selectedStyle;

  final List<Map<String, dynamic>> _helpStyles = [
    {
      'key': 'guided',
      'title': 'Guiado paso a paso',
      'description': 'Prefiero instrucciones claras y detalladas que me guíen en cada momento',
      'icon': Icons.assistant_direction,
      'color': Colors.blue.shade300,
    },
    {
      'key': 'independent',
      'title': 'Exploración libre',
      'description': 'Me gusta explorar las herramientas por mi cuenta y decidir qué usar',
      'icon': Icons.explore,
      'color': Colors.green.shade300,
    },
    {
      'key': 'quick',
      'title': 'Soluciones rápidas',
      'description': 'Quiero acceso inmediato a técnicas efectivas sin mucha preparación',
      'icon': Icons.flash_on,
      'color': Colors.orange.shade300,
    },
    {
      'key': 'deep',
      'title': 'Trabajo profundo',
      'description': 'Prefiero sesiones más largas y técnicas que trabajen las causas profundas',
      'icon': Icons.psychology,
      'color': Colors.purple.shade300,
    },
    {
      'key': 'social',
      'title': 'Apoyo social',
      'description': 'Me ayuda conectar con otros y compartir experiencias similares',
      'icon': Icons.people_alt,
      'color': Colors.pink.shade300,
    },
    {
      'key': 'private',
      'title': 'Privado y personal',
      'description': 'Prefiero trabajar en mi ansiedad de forma completamente privada',
      'icon': Icons.privacy_tip,
      'color': Colors.indigo.shade300,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Text(
            '¿Cómo prefieres recibir ayuda?',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.pink.shade700,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            'Esto nos ayuda a personalizar la forma en que te presentamos las herramientas y técnicas',
            style: TextStyle(
              fontSize: 16,
              color: Colors.pink.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          Expanded(
            child: ListView.builder(
              itemCount: _helpStyles.length,
              itemBuilder: (context, index) {
                final style = _helpStyles[index];
                final isSelected = _selectedStyle == style['key'];
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedStyle = style['key'];
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
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.pink.shade400 : style['color'],
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Icon(
                              style['icon'],
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  style['title'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.pink.shade700,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  style['description'],
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
                              size: 28,
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
              onPressed: _selectedStyle != null
                  ? () => widget.onHelpStyleSelected(_selectedStyle!)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedStyle != null ? Colors.pink.shade400 : Colors.grey.shade300,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 3,
              ),
              child: Text(
                '¡Completar configuración!',
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