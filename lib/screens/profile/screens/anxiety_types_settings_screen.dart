import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../providers/app_state.dart';
import '../../../widgets/onboarding_scaffold.dart';

class AnxietyTypesSettingsScreen extends StatefulWidget {
  @override
  _AnxietyTypesSettingsScreenState createState() => _AnxietyTypesSettingsScreenState();
}

class _AnxietyTypesSettingsScreenState extends State<AnxietyTypesSettingsScreen> {
  List<String> _selectedTypes = [];
  bool _isLoading = true;

  final List<Map<String, dynamic>> _anxietyTypes = [
    {
      'key': 'generalized',
      'title': 'Ansiedad Generalizada',
      'description': 'Preocupación constante por diferentes aspectos de la vida',
      'icon': Icons.psychology,
      'color': Colors.deepPurple,
    },
    {
      'key': 'social',
      'title': 'Ansiedad Social',
      'description': 'Miedo intenso en situaciones sociales o de rendimiento',
      'icon': Icons.people,
      'color': Colors.blue,
    },
    {
      'key': 'panic',
      'title': 'Ataques de Pánico',
      'description': 'Episodios súbitos de miedo intenso con síntomas físicos',
      'icon': Icons.warning,
      'color': Colors.red,
    },
    {
      'key': 'specific',
      'title': 'Fobias Específicas',
      'description': 'Miedo irracional a objetos o situaciones específicas',
      'icon': Icons.block,
      'color': Colors.orange,
    },
    {
      'key': 'performance',
      'title': 'Ansiedad de Rendimiento',
      'description': 'Nerviosismo al hablar en público o rendir exámenes',
      'icon': Icons.school,
      'color': Colors.green,
    },
    {
      'key': 'mixed',
      'title': 'Combinación',
      'description': 'Experimento diferentes tipos de ansiedad',
      'icon': Icons.apps,
      'color': Colors.teal,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrentAnxietyTypes();
  }

  void _loadCurrentAnxietyTypes() async {
    final appState = Provider.of<AppState>(context, listen: false);
    final userProfile = appState.userProfile;
    
    setState(() {
      if (userProfile != null && userProfile.anxietyTypes.isNotEmpty) {
        _selectedTypes = List<String>.from(userProfile.anxietyTypes);
      } else {
        _selectedTypes = [];
      }
      _isLoading = false;
    });
  }

  void _toggleAnxietyType(String key) {
    setState(() {
      if (_selectedTypes.contains(key)) {
        _selectedTypes.remove(key);
      } else {
        _selectedTypes.add(key);
      }
    });
  }

  Future<void> _saveAnxietyTypes() async {
    try {
      final appState = Provider.of<AppState>(context, listen: false);
      await appState.updateAnxietyTypes(_selectedTypes);
      
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tipos de ansiedad actualizados correctamente')),
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
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        title: Text('Mis Tipos de Ansiedad'),
        backgroundColor: Colors.pink.shade50,
        foregroundColor: Colors.pink.shade700,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _selectedTypes.isNotEmpty ? _saveAnxietyTypes : null,
            child: Text(
              'Guardar',
              style: TextStyle(
                color: _selectedTypes.isNotEmpty ? Colors.pink.shade700 : Colors.grey,
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
                '¿Qué tipos de ansiedad experimentas?',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink.shade700,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Puedes seleccionar varios tipos. Esto nos ayuda a personalizar las herramientas más efectivas para ti',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 32),
              Expanded(
                child: ListView.builder(
                  itemCount: _anxietyTypes.length,
                  itemBuilder: (context, index) {
                    final type = _anxietyTypes[index];
                    final isSelected = _selectedTypes.contains(type['key']);
                    
                    return OnboardingListItem(
                      icon: type['icon'],
                      title: type['title'],
                      description: type['description'],
                      isSelected: isSelected,
                      onTap: () => _toggleAnxietyType(type['key']),
                      primaryColor: Colors.deepPurple,
                      iconColor: type['color'],
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