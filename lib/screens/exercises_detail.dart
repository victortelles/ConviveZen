import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../data/personalization_data.dart';
import '../widgets/personalization_page.dart';

class ExercisesDetail extends StatefulWidget {
  @override
  _ExercisesDetailState createState() => _ExercisesDetailState();
}

class _ExercisesDetailState extends State<ExercisesDetail> {
  List<String> _selectedExercises = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserExercises();
  }

  Future<void> _loadUserExercises() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final appState = Provider.of<AppState>(context, listen: false);
      final userPreferences = await appState.getUserPreferences();
      if (userPreferences != null) {
        setState(() {
          _selectedExercises = userPreferences.selectedExercises;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cargar ejercicios: ${e.toString()}")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onExerciseSelected(String exercise) {
    setState(() {
      if (_selectedExercises.contains(exercise)) {
        _selectedExercises.remove(exercise);
      } else {
        _selectedExercises.add(exercise);
      }
    });
  }

  Future<void> _saveExercises() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final appState = Provider.of<AppState>(context, listen: false);
      //Obtener las preferencias seleccionadas
      final userPreferences = await appState.getUserPreferences();
      //Selecciona las preferencias
      userPreferences.selectedExercises = _selectedExercises;
      //Las actualiza
      await appState.updateUserPreferences(exerciseTypes: userPreferences.selectedExercises);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ejercicios actualizados.")),
      );
      Navigator.pop(context); // Go back to profile
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al guardar ejercicios: ${e.toString()}")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    Color backgroundColor = appState.isDarkMode ? Colors.black : Colors.white;
    Color textColor = appState.isDarkMode ? Colors.white : Colors.black;

    return _isLoading
        ? Scaffold(
            appBar: AppBar(
              title: Text("Tus Ejercicios", style: TextStyle(color: textColor)),
              backgroundColor: backgroundColor,
              iconTheme: IconThemeData(color: textColor),
            ),
            body: Center(child: CircularProgressIndicator()),
            backgroundColor: backgroundColor,
          )
        : PersonalizationPage(
            title: "Tus Ejercicios",
            instructionText: "Selecciona tus tipos de ejercicio",
            options: PersonalizationData.exerciseOptions,
            selectedValues: _selectedExercises,
            onOptionSelected: _onExerciseSelected,
            onNext: _saveExercises,
            showSelection: true,
            backgroundColor: backgroundColor,
            textColor: textColor,
          );
  }
}
