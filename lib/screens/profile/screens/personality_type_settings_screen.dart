import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../providers/app_state.dart';
import '../../../widgets/onboarding_scaffold.dart';

class PersonalityTypeSettingsScreen extends StatefulWidget {
  @override
  _PersonalityTypeSettingsScreenState createState() => _PersonalityTypeSettingsScreenState();
}

class _PersonalityTypeSettingsScreenState extends State<PersonalityTypeSettingsScreen> {
  String? _selectedPersonality;
  bool _isLoading = true;

  // Lista de tipos de personalidad disponibles
  final List<Map<String, dynamic>> _personalityTypes = [
    {
      'key': 'introvert',
      'title': 'Introvertido/a',
      'description': 'Prefiero actividades tranquilas y tiempo a solas para recargar energías',
      'icon': Icons.book,
      'color': Color(0xFF80CBC4),
      'iconColor': Color(0xFF00897B),
    },
    {
      'key': 'extrovert',
      'title': 'Extrovertido/a',
      'description': 'Me energizo con la interacción social y actividades grupales',
      'icon': Icons.groups,
      'color': Color(0xFFFFF59D),
      'iconColor': Color(0xFFF9A825),
    },
    {
      'key': 'ambivert',
      'title': 'Ambivertido/a',
      'description': 'Disfruto tanto del tiempo social como del tiempo a solas, según mi estado de ánimo',
      'icon': Icons.balance,
      'color': Color(0xFFB3E5FC),
      'iconColor': Color(0xFF0288D1),
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrentPersonality();
  }

  void _loadCurrentPersonality() async {
    final appState = Provider.of<AppState>(context, listen: false);

    setState(() {
      _isLoading = true;
    });

    try {
      // Cargar el tipo de personalidad actual del usuario
      final preferences = await appState.getUserPreferences();
      setState(() {
        _selectedPersonality = preferences.personalityType;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading personality: $e');
      setState(() {
        _selectedPersonality = null;
        _isLoading = false;
      });
    }
  }

  // metodo para seleccionar un tipo de personalidad
  void _selectPersonality(String personalityKey) {
    setState(() {
      _selectedPersonality = personalityKey;
    });
  }

  /// Método para guardar el tipo de personalidad seleccionado
  Future<void> _savePersonality() async {
    if (_selectedPersonality == null) return;

    try {
      final appState = Provider.of<AppState>(context, listen: false);
      await appState.updatePersonalityType(_selectedPersonality!);

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tipo de personalidad actualizado correctamente')),
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
      backgroundColor: Colors.teal.shade50,
      // AppBar - superior
      appBar: AppBar(
        title: Text('Mi Personalidad'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.teal.shade700,
        elevation: 0,
        actions: [
          // Botón de guardar
          TextButton(
            onPressed: _selectedPersonality != null ? _savePersonality : null,
            child: Text(
              'Guardar',
              style: TextStyle(
                color: _selectedPersonality != null ? Colors.teal.shade700 : Colors.grey,
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
              // Header
              Text(
                '¿Cómo te describes mejor?',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal.shade700,
                ),
              ),

              // Espaciado
              SizedBox(height: 8),

              // Subtítulo
              Text(
                'Esto nos ayuda a personalizar las herramientas según tu estilo de vida',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),

              // Espaciado
              SizedBox(height: 32),

              // Listado de personalidades
              Expanded(
                child: ListView.builder(
                  itemCount: _personalityTypes.length,
                  itemBuilder: (context, index) {
                    final type = _personalityTypes[index];
                    final isSelected = _selectedPersonality == type['key'];
                    return OnboardingListItem(
                      icon: type['icon'],
                      title: type['title'],
                      description: type['description'],
                      isSelected: isSelected,
                      onTap: () => _selectPersonality(type['key']),
                      primaryColor: Colors.teal,
                      iconColor: type['iconColor'] ?? Colors.blueGrey.shade600,
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