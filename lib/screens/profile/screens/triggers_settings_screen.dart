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

  // Lista de triggers disponibles
  final List<Map<String, dynamic>> _triggers = [
    {'key': 'exams', 'title': 'Exámenes/Evaluaciones', 'description': 'Pruebas académicas y evaluaciones', 'icon': Icons.assignment, 'color': Color(0xFFFFF59D), 'iconColor': Color(0xFFF9A825)},
    {'key': 'social_situations', 'title': 'Situaciones sociales', 'description': 'Interacciones con otras personas', 'icon': Icons.people, 'color': Color(0xFFB2EBF2), 'iconColor': Color(0xFF00838F)},
    {'key': 'public_speaking', 'title': 'Hablar en público', 'description': 'Presentaciones y exposiciones', 'icon': Icons.mic, 'color': Color(0xFFFFCCBC), 'iconColor': Color(0xFFD84315)},
    {'key': 'deadlines', 'title': 'Fechas límite', 'description': 'Presión por entregas y plazos', 'icon': Icons.schedule, 'color': Color(0xFFE1BEE7), 'iconColor': Color(0xFF6A1B9A)},
    {'key': 'crowds', 'title': 'Multitudes', 'description': 'Espacios con muchas personas', 'icon': Icons.groups, 'color': Color(0xFFC8E6C9), 'iconColor': Color(0xFF388E3C)},
    {'key': 'conflict', 'title': 'Conflictos', 'description': 'Discusiones y confrontaciones', 'icon': Icons.warning, 'color': Color(0xFFFFF9C4), 'iconColor': Color(0xFFFBC02D)},
    {'key': 'family_issues', 'title': 'Problemas familiares', 'description': 'Tensiones en el hogar', 'icon': Icons.home, 'color': Color(0xFFFFECB3), 'iconColor': Color(0xFFFFA000)},
    {'key': 'financial_stress', 'title': 'Estrés financiero', 'description': 'Preocupaciones económicas', 'icon': Icons.monetization_on, 'color': Color(0xFFFFF8E1), 'iconColor': Color(0xFFFF8F00)},
    {'key': 'health_concerns', 'title': 'Preocupaciones de salud', 'description': 'Inquietudes sobre bienestar físico', 'icon': Icons.health_and_safety, 'color': Color(0xFFFFCDD2), 'iconColor': Color(0xFFD32F2F)},
    {'key': 'future_uncertainty', 'title': 'Incertidumbre del futuro', 'description': 'Dudas sobre lo que viene', 'icon': Icons.help_outline, 'color': Color(0xFFB3E5FC), 'iconColor': Color(0xFF0288D1)},
    {'key': 'work_pressure', 'title': 'Presión laboral/académica', 'description': 'Estrés por responsabilidades', 'icon': Icons.work, 'color': Color(0xFFD7CCC8), 'iconColor': Color(0xFF5D4037)},
    {'key': 'relationships', 'title': 'Relaciones interpersonales', 'description': 'Problemas en vínculos personales', 'icon': Icons.favorite, 'color': Color(0xFFF8BBD0), 'iconColor': Color(0xFFC2185B)},
    {'key': 'technology', 'title': 'Problemas tecnológicos', 'description': 'Dificultades con dispositivos digitales', 'icon': Icons.devices, 'color': Color(0xFFCFD8DC), 'iconColor': Color(0xFF455A64)},
    {'key': 'change', 'title': 'Cambios inesperados', 'description': 'Situaciones imprevistas', 'icon': Icons.sync, 'color': Color(0xFFE0F2F1), 'iconColor': Color(0xFF00796B)},
    {'key': 'perfectionism', 'title': 'Perfeccionismo', 'description': 'Autoexigencia excesiva', 'icon': Icons.star, 'color': Color(0xFFFFF9C4), 'iconColor': Color(0xFFFBC02D)},
    {'key': 'loneliness', 'title': 'Soledad', 'description': 'Sentimientos de aislamiento', 'icon': Icons.person_outline, 'color': Color(0xFFE1F5FE), 'iconColor': Color(0xFF039BE5)},
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrentTriggers();
  }

  /// Método para cargar los triggers actuales del usuario
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

  /// Método para alternar un trigger seleccionado
  void _toggleTrigger(String triggerKey) {
    setState(() {
      if (_selectedTriggers.contains(triggerKey)) {
        _selectedTriggers.remove(triggerKey);
      } else {
        _selectedTriggers.add(triggerKey);
      }
    });
  }

  /// Método para guardar los triggers seleccionados
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
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
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
              // Título
              Text(
                '¿Qué situaciones suelen generar ansiedad en ti?',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow.shade700,
                ),
              ),

              // Espaciado
              SizedBox(height: 8),

              // Descripción
              Text(
                'Identifica tus triggers para recibir ayuda más personalizada. Puedes seleccionar varias opciones',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              // Espaciado
              SizedBox(height: 24),

              // Selected count
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.yellow.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.yellow.shade200),
                ),
                // Contenido
                child: Text(
                  'Triggers identificados: ${_selectedTriggers.length}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.yellow.shade800,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              //espaciado
              SizedBox(height: 20),

              // Lista de triggers
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
                      iconColor: trigger['iconColor'] ?? Colors.orange.shade600,
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