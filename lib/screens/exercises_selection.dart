import 'package:flutter/material.dart';
import 'package:convivezen/screens/sport_selection.dart';
import '../data/personalization_data.dart';
import '../models/user_preferences.dart';
import '../widgets/personalization_page.dart';

class ExcercisesSelection extends StatefulWidget {
  final UserPreferences userPreferences;

  const ExcercisesSelection({
    super.key,
    required this.userPreferences,
  });

  @override
  State<ExcercisesSelection> createState() => _ExcercisesSelectionState();
}

class _ExcercisesSelectionState extends State<ExcercisesSelection> {
  late UserPreferences _userPreferences;

  @override
  void initState() {
    super.initState();
    _userPreferences = widget.userPreferences;
  }

  void _onExerciseSelected(String exercise) {
    setState(() {
      if (_userPreferences.selectedExercises.contains(exercise)) {
        _userPreferences.selectedExercises.remove(exercise);
      } else {
        _userPreferences.selectedExercises.add(exercise);
      }
    });
  }

  void _navigateToNext() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SportsSelection(
          userPreferences: _userPreferences,
        ),
      ),
    );
  }

  //Funcionalidad para saltar la seleccion de habitos.
  void _skipSelection() {
    _navigateToNext();
  }

  @override
  Widget build(BuildContext context) {
    return PersonalizationPage(
      title: 'Personalizacion',
      instructionText: 'Selecciona tus ejercicios preferidos:',
      options: PersonalizationData.exerciseOptions,
      selectedValues: _userPreferences.selectedExercises,
      onOptionSelected: _onExerciseSelected,
      onNext: _navigateToNext,
      onSkip: _skipSelection,
    );
  }
}