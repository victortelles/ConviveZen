import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/personalization_data.dart';
import '../models/user_preferences.dart';
import '../providers/app_state.dart';
import '../widgets/personalization_page.dart';
import 'habits_selection.dart';

class GenderSelection extends StatefulWidget {
  final UserPreferences userPreferences;

  const GenderSelection({
    super.key,
    required this.userPreferences,
  });

  @override
  State<GenderSelection> createState() => _GenderSelectionState();
}

class _GenderSelectionState extends State<GenderSelection> {
  late UserPreferences _userPreferences;

  @override
  void initState() {
    super.initState();
    _userPreferences = widget.userPreferences;
  }

  //Funcionalidad al seleccionar el genero.
  void _onGenderSelected(String gender) {
    setState(() {
      if (_userPreferences.gender == gender) {
        _userPreferences.gender == null;
      } else {
        _userPreferences.gender = gender;
      }
    });
  }

  //Navegar a la siguiente pantalla.
  void _navigateToNext() async {
    if (_userPreferences.gender != null) {
      try {
        // Guardar la selección de género en Firestore a través de AppState
        await Provider.of<AppState>(context, listen: false)
            .updateUserPreferences(gender: _userPreferences.gender);

        // Navegar a la siguiente pantalla
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HabitsSelection(
              userPreferences: _userPreferences,
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al guardar: ${e.toString()}")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor selecciona una opción")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Pantalla para seleccionar el género
    return PersonalizationPage(
      title: 'Personalización',
      instructionText: 'Selecciona tu género',
      options: PersonalizationData.genderOptions,
      selectedValues: _userPreferences.gender != null ? [_userPreferences.gender!] : [],
      onOptionSelected: _onGenderSelected,
      onNext: _navigateToNext,
      showSelection: false,
    );
  }
}