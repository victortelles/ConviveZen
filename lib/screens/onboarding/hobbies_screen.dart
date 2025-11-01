import 'package:flutter/material.dart';

class HobbiesScreen extends StatefulWidget {
  final Function(List<String>) onHobbiesSelected;

  const HobbiesScreen({Key? key, required this.onHobbiesSelected}) : super(key: key);

  @override
  _HobbiesScreenState createState() => _HobbiesScreenState();
}

class _HobbiesScreenState extends State<HobbiesScreen> {
  List<String> _selectedHobbies = [];

  final List<Map<String, dynamic>> _hobbies = [
    {'key': 'reading', 'title': 'Lectura', 'icon': Icons.book},
    {'key': 'music', 'title': 'Música', 'icon': Icons.music_note},
    {'key': 'sports', 'title': 'Deportes', 'icon': Icons.sports_soccer},
    {'key': 'art', 'title': 'Arte y Dibujo', 'icon': Icons.palette},
    {'key': 'cooking', 'title': 'Cocinar', 'icon': Icons.restaurant},
    {'key': 'gaming', 'title': 'Videojuegos', 'icon': Icons.sports_esports},
    {'key': 'nature', 'title': 'Naturaleza', 'icon': Icons.nature},
    {'key': 'photography', 'title': 'Fotografía', 'icon': Icons.camera_alt},
    {'key': 'dancing', 'title': 'Bailar', 'icon': Icons.music_video},
    {'key': 'writing', 'title': 'Escribir', 'icon': Icons.edit},
    {'key': 'travel', 'title': 'Viajar', 'icon': Icons.flight},
    {'key': 'crafts', 'title': 'Manualidades', 'icon': Icons.handyman},
    {'key': 'movies', 'title': 'Películas/Series', 'icon': Icons.movie},
    {'key': 'meditation', 'title': 'Meditación', 'icon': Icons.self_improvement},
    {'key': 'socializing', 'title': 'Socializar', 'icon': Icons.people},
    {'key': 'learning', 'title': 'Aprender cosas nuevas', 'icon': Icons.school},
  ];

  void _toggleHobby(String hobbyKey) {
    setState(() {
      if (_selectedHobbies.contains(hobbyKey)) {
        _selectedHobbies.remove(hobbyKey);
      } else {
        _selectedHobbies.add(hobbyKey);
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
            '¿Cuáles son tus hobbies o intereses?',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.pink.shade700,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            'Selecciona todas las actividades que disfrutas. Esto nos ayuda a personalizar tus herramientas de relajación',
            style: TextStyle(
              fontSize: 16,
              color: Colors.pink.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          Text(
            'Seleccionados: ${_selectedHobbies.length}',
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
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.3,
              ),
              itemCount: _hobbies.length,
              itemBuilder: (context, index) {
                final hobby = _hobbies[index];
                final isSelected = _selectedHobbies.contains(hobby['key']);
                
                return GestureDetector(
                  onTap: () => _toggleHobby(hobby['key']),
                  child: Container(
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
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.pink.shade400 : Colors.pink.shade200,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Icon(
                            hobby['icon'],
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          hobby['title'],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.pink.shade700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (isSelected) ...[
                          SizedBox(height: 4),
                          Icon(
                            Icons.check_circle,
                            color: Colors.pink.shade400,
                            size: 16,
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
              onPressed: _selectedHobbies.isNotEmpty
                  ? () => widget.onHobbiesSelected(_selectedHobbies)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedHobbies.isNotEmpty ? Colors.pink.shade400 : Colors.grey.shade300,
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