import 'package:flutter/material.dart';
import 'package:convivezen/screens/days_selection.dart';
import '../data/personalization_data.dart';
import '../models/user_preferences.dart';
import '../widgets/personalization_page.dart';

class SportsSelection extends StatefulWidget {
  final UserPreferences userPreferences;

  const SportsSelection({
    super.key,
    required this.userPreferences,
  });

  @override
  State<SportsSelection> createState() => _SportsSelectionState();
}

class _SportsSelectionState extends State<SportsSelection> {
  late UserPreferences _userPreferences;

  @override
  void initState() {
    super.initState();
    _userPreferences = widget.userPreferences;
  }

  void _onSportSelected(String sport) {
    setState(() {
      if (_userPreferences.selectedSports.contains(sport)) {
        _userPreferences.selectedSports.remove(sport);
      } else {
        if (_userPreferences.selectedSports.length < 5 || _userPreferences.selectedSports.contains(sport)) {
          _userPreferences.selectedSports.add(sport);
        }
      }
    });
  }

  void _navigateToNext() {
    Navigator.of(context).push (
      MaterialPageRoute(
        builder: (context) => DaysSelection(
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
      instructionText: 'Selecciona tus deportes favoritos:',
      options: PersonalizationData.sportOptions,
      selectedValues: _userPreferences.selectedSports,
      onOptionSelected: _onSportSelected,
      onNext: _navigateToNext,
      maxSelections: 5,
      onSkip: _skipSelection,
    );
  }
}