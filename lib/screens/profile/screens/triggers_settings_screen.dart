import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../providers/app_state.dart';
import '../../../widgets/onboarding_scaffold.dart';

class TriggersSettingsScreen extends StatefulWidget {
  @override
  _TriggersSettingsScreenState createState() => _TriggersSettingsScreenState();
}

class _TriggersSettingsScreenState extends State<TriggersSettingsScreen> {
  List<String> _selectedTriggers = [];
  bool _isLoading = true;

  final List<Map<String, dynamic>> _triggers = [
    {'key': 'exams', 'title': 'Exámenes/Evaluaciones', 'description': 'Pruebas académicas y evaluaciones', 'icon': Icons.assignment},
    {'key': 'social_situations', 'title': 'Situaciones sociales', 'description': 'Interacciones con otras personas', 'icon': Icons.people},
    {'key': 'public_speaking', 'title': 'Hablar en público', 'description': 'Presentaciones y exposiciones', 'icon': Icons.mic},
    {'key': 'deadlines', 'title': 'Fechas límite', 'description': 'Presión por entregas y plazos', 'icon': Icons.schedule},
    {'key': 'crowds', 'title': 'Multitudes', 'description': 'Espacios con muchas personas', 'icon': Icons.groups},
    {'key': 'conflict', 'title': 'Conflictos', 'description': 'Discusiones y confrontaciones', 'icon': Icons.warning},
    {'key': 'family_issues', 'title': 'Problemas familiares', 'description': 'Tensiones en el hogar', 'icon': Icons.home},
    {'key': 'financial_stress', 'title': 'Estrés financiero', 'description': 'Preocupaciones económicas', 'icon': Icons.monetization_on},
    {'key': 'health_concerns', 'title': 'Preocupaciones de salud', 'description': 'Inquietudes sobre bienestar físico', 'icon': Icons.health_and_safety},
    {'key': 'future_uncertainty', 'title': 'Incertidumbre del futuro', 'description': 'Dudas sobre lo que viene', 'icon': Icons.help_outline},
    {'key': 'work_pressure', 'title': 'Presión laboral/académica', 'description': 'Estrés por responsabilidades', 'icon': Icons.work},
    {'key': 'relationships', 'title': 'Relaciones interpersonales', 'description': 'Problemas en vínculos personales', 'icon': Icons.favorite},
    {'key': 'technology', 'title': 'Problemas tecnológicos', 'description': 'Dificultades con dispositivos digitales', 'icon': Icons.devices},
    {'key': 'change', 'title': 'Cambios inesperados', 'description': 'Situaciones imprevistas', 'icon': Icons.sync},
    {'key': 'perfectionism', 'title': 'Perfeccionismo', 'description': 'Autoexigencia excesiva', 'icon': Icons.star},
    {'key': 'loneliness', 'title': 'Soledad', 'description': 'Sentimientos de aislamiento', 'icon': Icons.person_outline},
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrentTriggers();
  }

  void _loadCurrentTriggers() async {
    final appState = Provider.of<AppState>(context, listen: false);
    
    setState(() {
      _isLoading = true;
    });

    try {
      final preferences = await appState.getUserPreferences();
      setState(() {
        _selectedTriggers = List<String>.from(preferences.triggers);
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading triggers: $e');
      setState(() {
        _selectedTriggers = [];
        _isLoading = false;
      });
    }
  }

  void _toggleTrigger(String triggerKey) {
    setState(() {
      if (_selectedTriggers.contains(triggerKey)) {
        _selectedTriggers.remove(triggerKey);
      } else {
        _selectedTriggers.add(triggerKey);
      }
    });
  }

  Future<void> _saveTriggers() async {
    try {
      final appState = Provider.of<AppState>(context, listen: false);
      await appState.updateTriggers(_selectedTriggers);
      
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Triggers actualizados correctamente')),
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
      backgroundColor: Colors.yellow.shade50,
      appBar: AppBar(
        title: Text('Mis Triggers'),
        backgroundColor: Colors.yellow.shade50,
        foregroundColor: Colors.yellow.shade700,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _saveTriggers,
            child: Text(
              'Guardar (${_selectedTriggers.length})',
              style: TextStyle(
                color: Colors.yellow.shade700,
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
                '¿Qué situaciones suelen generar ansiedad en ti?',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow.shade700,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Identifica tus triggers para recibir ayuda más personalizada. Puedes seleccionar varias opciones',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 24),

              // Selected count
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.yellow.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.yellow.shade200),
                ),
                child: Text(
                  'Triggers identificados: ${_selectedTriggers.length}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.yellow.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 20),
              
              // Triggers list
              Expanded(
                child: ListView.builder(
                  itemCount: _triggers.length,
                  itemBuilder: (context, index) {
                    final trigger = _triggers[index];
                    final isSelected = _selectedTriggers.contains(trigger['key']);
                    
                    return OnboardingListItem(
                      icon: trigger['icon'],
                      title: trigger['title'],
                      description: trigger['description'],
                      isSelected: isSelected,
                      onTap: () => _toggleTrigger(trigger['key']),
                      primaryColor: Colors.yellow,
                      iconColor: Colors.orange.shade600,
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