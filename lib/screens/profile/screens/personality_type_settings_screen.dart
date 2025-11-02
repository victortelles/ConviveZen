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

  final List<Map<String, dynamic>> _personalityTypes = [
    {
      'key': 'introvert',
      'title': 'Introvertido/a',
      'description': 'Prefiero actividades tranquilas y tiempo a solas para recargar energías',
      'icon': Icons.book,
    },
    {
      'key': 'extrovert',
      'title': 'Extrovertido/a',
      'description': 'Me energizo con la interacción social y actividades grupales',
      'icon': Icons.groups,
    },
    {
      'key': 'ambivert',
      'title': 'Ambivertido/a',
      'description': 'Disfruto tanto del tiempo social como del tiempo a solas, según mi estado de ánimo',
      'icon': Icons.balance,
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

  void _selectPersonality(String personalityKey) {
    setState(() {
      _selectedPersonality = personalityKey;
    });
  }

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
      appBar: AppBar(
        title: Text('Mi Personalidad'),
        backgroundColor: Colors.teal.shade50,
        foregroundColor: Colors.teal.shade700,
        elevation: 0,
        actions: [
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
              Text(
                '¿Cómo te describes mejor?',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal.shade700,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Esto nos ayuda a personalizar las herramientas según tu estilo de vida',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 32),

              // Personality types list
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
                      iconColor: Colors.blueGrey.shade600,
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