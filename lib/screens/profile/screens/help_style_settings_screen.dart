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

  final List<Map<String, dynamic>> _helpStyles = [
    {
      'key': 'guided',
      'title': 'Guía Paso a Paso',
      'description': 'Prefiero instrucciones claras y detalladas durante las crisis',
      'icon': Icons.assistant_navigation,
      'color': Colors.blue,
    },
    {
      'key': 'self_directed',
      'title': 'Autodirigido',
      'description': 'Prefiero tener opciones y decidir qué hacer por mí mismo',
      'icon': Icons.explore,
      'color': Colors.purple,
    },
    {
      'key': 'mixed',
      'title': 'Combinación',
      'description': 'Me gusta alternar entre guía estructurada y libertad de elección',
      'icon': Icons.tune,
      'color': Colors.orange,
    },
    {
      'key': 'visual',
      'title': 'Apoyo Visual',
      'description': 'Prefiero imágenes, videos y contenido visual para calmarme',
      'icon': Icons.visibility,
      'color': Colors.teal,
    },
    {
      'key': 'audio',
      'title': 'Apoyo Auditivo',
      'description': 'Prefiero música, sonidos relajantes y meditaciones guiadas',
      'icon': Icons.headphones,
      'color': Colors.green,
    },
    {
      'key': 'interactive',
      'title': 'Interactivo',
      'description': 'Me ayuda chatear o interactuar con ejercicios dinámicos',
      'icon': Icons.chat,
      'color': Colors.indigo,
    },
    {
      'key': 'breathing',
      'title': 'Ejercicios de Respiración',
      'description': 'Los ejercicios de respiración son mi herramienta principal',
      'icon': Icons.air,
      'color': Colors.cyan,
    },
    {
      'key': 'grounding',
      'title': 'Técnicas de Grounding',
      'description': 'Prefiero ejercicios que me conecten con el presente',
      'icon': Icons.nature_people,
      'color': Colors.brown,
    },
    {
      'key': 'gentle',
      'title': 'Apoyo Suave',
      'description': 'Necesito un enfoque muy delicado y comprensivo',
      'icon': Icons.favorite,
      'color': Colors.pink,
    },
    {
      'key': 'energetic',
      'title': 'Apoyo Enérgico',
      'description': 'Prefiero motivación directa y ejercicios más activos',
      'icon': Icons.flash_on,
      'color': Colors.amber,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrentHelpStyle();
  }

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

  void _selectHelpStyle(String key) {
    setState(() {
      _selectedHelpStyle = key;
    });
  }

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
      appBar: AppBar(
        title: Text('Cómo Prefiero Recibir Apoyo'),
        backgroundColor: Colors.red.shade50,
        foregroundColor: Colors.red.shade700,
        elevation: 0,
        actions: [
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
              Text(
                '¿Cómo prefieres recibir apoyo en momentos difíciles?',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Selecciona el estilo de apoyo que mejor se adapte a ti. Esto nos ayuda a personalizar tu experiencia',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 32),
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