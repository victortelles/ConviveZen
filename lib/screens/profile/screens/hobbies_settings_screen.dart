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

  final List<Map<String, dynamic>> _hobbies = [
    {
      'key': 'reading',
      'title': 'Lectura',
      'description': 'Leer libros, revistas o artículos',
      'icon': Icons.book,
      'color': Colors.brown,
    },
    {
      'key': 'yoga',
      'title': 'Yoga',
      'description': 'Práctica de posturas y respiración',
      'icon': Icons.self_improvement,
      'color': Colors.purple,
    },
    {
      'key': 'meditation',
      'title': 'Meditación',
      'description': 'Práctica de mindfulness y relajación',
      'icon': Icons.spa,
      'color': Colors.deepPurple,
    },
    {
      'key': 'walking',
      'title': 'Caminar',
      'description': 'Paseos relajantes al aire libre',
      'icon': Icons.directions_walk,
      'color': Colors.green,
    },
    {
      'key': 'gardening',
      'title': 'Jardinería',
      'description': 'Cuidar plantas y jardines',
      'icon': Icons.local_florist,
      'color': Colors.lightGreen,
    },
    {
      'key': 'painting',
      'title': 'Pintura/Dibujo',
      'description': 'Expresión artística y creatividad',
      'icon': Icons.brush,
      'color': Colors.orange,
    },
    {
      'key': 'cooking',
      'title': 'Cocinar',
      'description': 'Preparar comidas y experimentar recetas',
      'icon': Icons.restaurant,
      'color': Colors.red,
    },
    {
      'key': 'music',
      'title': 'Tocar Instrumentos',
      'description': 'Guitarra, piano u otros instrumentos',
      'icon': Icons.piano,
      'color': Colors.blue,
    },
    {
      'key': 'crafts',
      'title': 'Manualidades',
      'description': 'Tejido, costura, trabajos manuales',
      'icon': Icons.construction,
      'color': Colors.amber,
    },
    {
      'key': 'photography',
      'title': 'Fotografía',
      'description': 'Capturar momentos y paisajes',
      'icon': Icons.camera_alt,
      'color': Colors.teal,
    },
    {
      'key': 'writing',
      'title': 'Escritura',
      'description': 'Diario personal, poesía o cuentos',
      'icon': Icons.edit,
      'color': Colors.indigo,
    },
    {
      'key': 'puzzles',
      'title': 'Rompecabezas',
      'description': 'Sudoku, crucigramas, puzzles',
      'icon': Icons.extension,
      'color': Colors.cyan,
    },
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