import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../providers/app_state.dart';
import '../../../widgets/onboarding_scaffold.dart';

class HobbiesSettingsScreen extends StatefulWidget {
  @override
  _HobbiesSettingsScreenState createState() => _HobbiesSettingsScreenState();
}

class _HobbiesSettingsScreenState extends State<HobbiesSettingsScreen> {
  List<String> _selectedHobbies = [];
  bool _isLoading = true;

  // Lista completa de hobbies (identica a onboarding)
  final List<Map<String, dynamic>> _hobbies = [
    {'key': 'reading', 'title': 'Lectura', 'description': 'Leer libros, revistas y artículos', 'icon': Icons.book, 'color': Colors.brown},
    {'key': 'music', 'title': 'Música', 'description': 'Escuchar o crear música', 'icon': Icons.music_note, 'color': Colors.blue},
    {'key': 'sports', 'title': 'Deportes', 'description': 'Actividades físicas y ejercicio', 'icon': Icons.sports_soccer, 'color': Colors.green},
    {'key': 'art', 'title': 'Arte y Dibujo', 'description': 'Expresión artística y creativa', 'icon': Icons.palette, 'color': Colors.orange},
    {'key': 'cooking', 'title': 'Cocinar', 'description': 'Preparar comidas y experimentar con recetas', 'icon': Icons.restaurant, 'color': Colors.red},
    {'key': 'gaming', 'title': 'Videojuegos', 'description': 'Juegos digitales y entretenimiento', 'icon': Icons.sports_esports, 'color': Colors.deepPurple},
    {'key': 'nature', 'title': 'Naturaleza', 'description': 'Actividades al aire libre', 'icon': Icons.nature, 'color': Colors.lightGreen},
    {'key': 'photography', 'title': 'Fotografía', 'description': 'Capturar momentos y paisajes', 'icon': Icons.camera_alt, 'color': Colors.teal},
    {'key': 'dancing', 'title': 'Bailar', 'description': 'Expresión corporal y movimiento', 'icon': Icons.music_video, 'color': Colors.pink},
    {'key': 'writing', 'title': 'Escribir', 'description': 'Crear textos, historias o diarios', 'icon': Icons.edit, 'color': Colors.indigo},
    {'key': 'travel', 'title': 'Viajar', 'description': 'Explorar nuevos lugares', 'icon': Icons.flight, 'color': Colors.cyan},
    {'key': 'crafts', 'title': 'Manualidades', 'description': 'Crear objetos con las manos', 'icon': Icons.handyman, 'color': Colors.amber},
    {'key': 'movies', 'title': 'Películas/Series', 'description': 'Entretenimiento audiovisual', 'icon': Icons.movie, 'color': Colors.deepOrange},
    {'key': 'meditation', 'title': 'Meditación', 'description': 'Prácticas de mindfulness y relajación', 'icon': Icons.self_improvement, 'color': Colors.deepPurple},
    {'key': 'socializing', 'title': 'Socializar', 'description': 'Pasar tiempo con amigos y familia', 'icon': Icons.people, 'color': Colors.purple},
    {'key': 'learning', 'title': 'Aprender cosas nuevas', 'description': 'Cursos, talleres y educación continua', 'icon': Icons.school, 'color': Colors.blueGrey},
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrentHobbies();
  }

  void _loadCurrentHobbies() async {
    final appState = Provider.of<AppState>(context, listen: false);
    
    setState(() {
      _isLoading = true;
    });

    try {
      final preferences = await appState.getUserPreferences();
      setState(() {
        _selectedHobbies = List<String>.from(preferences.hobbies);
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading hobbies: $e');
      setState(() {
        _selectedHobbies = [];
        _isLoading = false;
      });
    }
  }

  void _toggleHobby(String key) {
    setState(() {
      if (_selectedHobbies.contains(key)) {
        _selectedHobbies.remove(key);
      } else {
        _selectedHobbies.add(key);
      }
    });
  }

  Future<void> _saveHobbies() async {
    try {
      final appState = Provider.of<AppState>(context, listen: false);
      await appState.updateHobbies(_selectedHobbies);
      
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Actividades favoritas actualizadas correctamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: Text('Actividades que me Relajan'),
        backgroundColor: Colors.green.shade50,
        foregroundColor: Colors.green.shade700,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _selectedHobbies.isNotEmpty ? _saveHobbies : null,
            child: Text(
              _selectedHobbies.isEmpty 
                ? 'Guardar' 
                : 'Guardar (${_selectedHobbies.length})',
              style: TextStyle(
                color: _selectedHobbies.isNotEmpty ? Colors.green.shade700 : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: _isLoading 
        ? Center(child: CircularProgressIndicator())
        : Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¿Qué actividades te ayudan a relajarte?',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Selecciona las actividades que más te tranquilizan. Las incluiremos en tus recomendaciones personalizadas',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 32),
              Expanded(
                child: ListView.builder(
                  itemCount: _hobbies.length,
                  itemBuilder: (context, index) {
                    final hobby = _hobbies[index];
                    final isSelected = _selectedHobbies.contains(hobby['key']);
                    
                    return OnboardingListItem(
                      icon: hobby['icon'],
                      title: hobby['title'],
                      description: hobby['description'],
                      isSelected: isSelected,
                      onTap: () => _toggleHobby(hobby['key']),
                      primaryColor: Colors.green,
                      iconColor: hobby['color'],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
    );
  }
}