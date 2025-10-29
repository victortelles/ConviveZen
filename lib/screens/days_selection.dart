import 'package:flutter/material.dart';
import '../data/personalization_data.dart';
import '../models/user_preferences.dart';
import '../widgets/personalization_page.dart';
import 'summary.dart';

class DaysSelection extends StatefulWidget {
  final UserPreferences userPreferences;

  const DaysSelection({
    super.key,
    required this.userPreferences,
  });

  @override
  State<DaysSelection> createState() => _DaysSelectionState();
}

class _DaysSelectionState extends State<DaysSelection> {
  late UserPreferences _userPreferences;

  @override
  void initState() {
    super.initState();
    _userPreferences = widget.userPreferences;
  }

  void _onDaySelected(String day) {
    setState(() {
      if (_userPreferences.selectedDays.contains(day)) {
        _userPreferences.selectedDays.remove(day);
      } else {
        _userPreferences.selectedDays.add(day);
      }
    });
  }

  void _navigateToNext() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Summary(
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
      instructionText: 'Selecciona los dias de la semana que prefieres entrenar:',
      options: PersonalizationData.dayOptions,
      selectedValues: _userPreferences.selectedDays,
      onOptionSelected: _onDaySelected,
      onNext: _navigateToNext,
      onSkip: _skipSelection,
    );
  }
}