import 'package:flutter/material.dart';
import '../data/personalization_data.dart';
import '../models/user_preferences.dart';
import '../widgets/personalization_page.dart';
import 'exercises_selection.dart';

class HabitsSelection extends StatefulWidget {
  final UserPreferences userPreferences;

  const HabitsSelection({
    super.key,
    required this.userPreferences
  });

  @override
  State<HabitsSelection> createState() => _HabitsSelectionState();
}

class _HabitsSelectionState extends State<HabitsSelection> {
  late UserPreferences _userPreferences;

  @override
  void initState() {
    super.initState();
    //Crear una copia para evitar mutaciones no deseadas
    _userPreferences = widget.userPreferences;
  }

  void _onHabitSelected(String habit) {
    setState(() {
      if (_userPreferences.selectedHabits.contains(habit)) {
        _userPreferences.selectedHabits.remove(habit);
        print(_userPreferences.selectedHabits);
      } else {
        _userPreferences.selectedHabits.add(habit);
        print(_userPreferences.selectedHabits);
      }
    });
  }

  void _navigateToNext() {
    //Pasar la referencia actualizada a la siguiente pantalla
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ExcercisesSelection(
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
      instructionText: 'Selecciona tus habitos',
      options: PersonalizationData.habitOptions,
      selectedValues: _userPreferences.selectedHabits,
      onOptionSelected: _onHabitSelected,
      onNext: _navigateToNext,
      maxSelections: 0,
      showSelection: true,
      onSkip: _skipSelection,
    );
  }
}
