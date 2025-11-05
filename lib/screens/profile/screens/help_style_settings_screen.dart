import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../providers/app_state.dart';
import '../../../widgets/onboarding_scaffold.dart';

class HelpStyleSettingsScreen extends StatefulWidget {
  @override
  _HelpStyleSettingsScreenState createState() => _HelpStyleSettingsScreenState();
}

class _HelpStyleSettingsScreenState extends State<HelpStyleSettingsScreen> {
  String _selectedHelpStyle = '';
  bool _isLoading = true;

  // Lista de estilos de ayuda disponibles
  final List<Map<String, dynamic>> _helpStyles = [
    {
      'key': 'guided',
      'title': 'Guiado paso a paso',
      'description': 'Prefiero instrucciones claras y detalladas que me guíen en cada momento',
      'icon': Icons.assistant_direction,
      'color': Colors.blue,
    },
    {
      'key': 'independent',
      'title': 'Exploración libre',
      'description': 'Me gusta explorar las herramientas por mi cuenta y decidir qué usar',
      'icon': Icons.explore,
      'color': Colors.purple,
    },
    {
      'key': 'quick',
      'title': 'Soluciones rápidas',
      'description': 'Quiero acceso inmediato a técnicas efectivas sin mucha preparación',
      'icon': Icons.flash_on,
      'color': Colors.orange,
    },
    {
      'key': 'deep',
      'title': 'Trabajo profundo',
      'description': 'Prefiero sesiones más largas y técnicas que trabajen las causas profundas',
      'icon': Icons.psychology,
      'color': Colors.teal,
    },
    {
      'key': 'social',
      'title': 'Apoyo social',
      'description': 'Me ayuda conectar con otros y compartir experiencias similares',
      'icon': Icons.people_alt,
      'color': Colors.green,
    },
    {
      'key': 'private',
      'title': 'Privado y personal',
      'description': 'Prefiero trabajar en mi ansiedad de forma completamente privada',
      'icon': Icons.privacy_tip,
      'color': Colors.indigo,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrentHelpStyle();
  }

  // Cargar el estilo de ayuda actual del usuario
  void _loadCurrentHelpStyle() async {
    final appState = Provider.of<AppState>(context, listen: false);
    
    setState(() {
      _isLoading = true;
    });

    try {
      final preferences = await appState.getUserPreferences();
      setState(() {
        _selectedHelpStyle = preferences.helpStyle;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading help style: $e');
      setState(() {
        _selectedHelpStyle = '';
        _isLoading = false;
      });
    }
  }

  // Método para seleccionar un estilo de ayuda
  void _selectHelpStyle(String key) {
    setState(() {
      _selectedHelpStyle = key;
    });
  }

  // Método para guardar el estilo de ayuda seleccionado
  Future<void> _saveHelpStyle() async {
    try {
      final appState = Provider.of<AppState>(context, listen: false);
      await appState.updateHelpStyle(_selectedHelpStyle);
      
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Estilo de apoyo actualizado correctamente')),
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
      backgroundColor: Colors.red.shade50,
      // AppBar - superior
      appBar: AppBar(
        title: Text('Preferencia Recibir Apoyo'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.red.shade700,
        elevation: 0,
        actions: [
          // Botón de guardar
          TextButton(
            onPressed: _selectedHelpStyle.isNotEmpty ? _saveHelpStyle : null,
            child: Text(
              'Guardar',
              style: TextStyle(
                color: _selectedHelpStyle.isNotEmpty ? Colors.red.shade700 : Colors.grey,
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
              // Título y descripción
              Text(
                '¿Cómo prefieres recibir apoyo en momentos difíciles?',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
              ),
              // Espaciado
              SizedBox(height: 8),

              // Descripción
              Text(
                'Selecciona el estilo de apoyo que mejor se adapte a ti. Esto nos ayuda a personalizar tu experiencia',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              // Espaciado
              SizedBox(height: 32),

              // Lista de estilos de ayuda
              Expanded(
                child: ListView.builder(
                  itemCount: _helpStyles.length,
                  itemBuilder: (context, index) {
                    final style = _helpStyles[index];
                    final isSelected = _selectedHelpStyle == style['key'];

                    return OnboardingListItem(
                      icon: style['icon'],
                      title: style['title'],
                      description: style['description'],
                      isSelected: isSelected,
                      onTap: () => _selectHelpStyle(style['key']),
                      primaryColor: Colors.red,
                      iconColor: style['color'],
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