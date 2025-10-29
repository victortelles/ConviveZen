import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_preferences.dart';
import '../providers/app_state.dart';
import 'home.dart';

class Summary extends StatefulWidget {
  final UserPreferences userPreferences;

  const Summary({
    Key? key,
    required this.userPreferences,
  }) : super(key: key);

  @override
  State<Summary> createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen'),
      ),
      body: _isSaving
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '¡Tu perfil está listo!',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Hemos personalizado tu experiencia basada en tus preferencias:',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(height: 20),
                  _buildPreferenceSection('Género',
                      widget.userPreferences.gender ?? 'No especificado'),
                  _buildPreferenceSection(
                      'Hábitos seleccionados',
                      widget.userPreferences.selectedHabits.isEmpty
                          ? 'Ninguno seleccionado'
                          : widget.userPreferences.selectedHabits.join(', ')),
                  _buildPreferenceSection(
                      'Deportes',
                      widget.userPreferences.selectedSports.isEmpty
                          ? 'Ninguno seleccionado'
                          : widget.userPreferences.selectedSports.join(', ')),
                  _buildPreferenceSection(
                      'Tipos de ejercicios',
                      widget.userPreferences.selectedExercises.isEmpty
                          ? 'Ninguno seleccionado'
                          : widget.userPreferences.selectedExercises.join(', ')),
                  _buildPreferenceSection(
                      'Días de entrenamiento',
                      widget.userPreferences.selectedDays.isEmpty
                          ? 'Ninguno seleccionado'
                          : widget.userPreferences.selectedDays.join(', ')),
                  SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                      ),
                      onPressed: _saveAndNavigate,
                      child: Text(
                        'Comenzar mi experiencia',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildPreferenceSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 4),
          Text(
            content,
            style: TextStyle(fontSize: 15),
          ),
          Divider(),
        ],
      ),
    );
  }

  Future<void> _saveAndNavigate() async {
    setState(() {
      _isSaving = true;
    });

    try {
      // Guardar todas las preferencias del usuario en Firestore
      await Provider.of<AppState>(context, listen: false).updateUserPreferences(
        gender: widget.userPreferences.gender,
        habits: widget.userPreferences.selectedHabits,
        sports: widget.userPreferences.selectedSports,
        exerciseTypes: widget.userPreferences.selectedExercises,
        trainingDays: widget.userPreferences.selectedDays,
      );

      // Navegar a la pantalla principal
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false, // Eliminar todas las rutas anteriores del stack
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Error al guardar las preferencias: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }
}
