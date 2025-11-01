import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../data/personalization_data.dart';
import '../widgets/personalization_page.dart';

class HabitsDetail extends StatefulWidget {
  const HabitsDetail({Key? key}) : super(key: key);

  @override
  _HabitsDetailState createState() => _HabitsDetailState();
}

class _HabitsDetailState extends State<HabitsDetail> {
  List<String> _selectedHabits = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserHabits();
  }

  Future<void> _loadUserHabits() async {
    try {
      final appState = Provider.of<AppState>(context, listen: false);
      final userPreferences = await appState.getUserHabits();
      setState(() {
        _selectedHabits = userPreferences;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading user habits: $e');

      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cargar los hábitos: ${e.toString()}")),
      );
    }
  }

  void _onHabitSelected(String habit) {
    setState(() {
      if (_selectedHabits.contains(habit)) {
        _selectedHabits.remove(habit);
      } else {
        _selectedHabits.add(habit);
      }
    });
  }

  Future<void> _savePreferences() async {
    try {
      final appState = Provider.of<AppState>(context, listen: false);
      // Guardar las preferencias seleccionadas
      await appState.updateUserPreferences(habits: _selectedHabits);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Error al actualizar los hábitos: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Scaffold(
            appBar: AppBar(title: const Text("Tus Hábitos")),
            body: const Center(child: CircularProgressIndicator()),
          )
        : PersonalizationPage(
            title: "Tus Hábitos",
            instructionText: "Selecciona tus hábitos",
            options: PersonalizationData.habitOptions,
            selectedValues: _selectedHabits,
            onOptionSelected: _onHabitSelected,
            onNext: _savePreferences,
            maxSelections: 0,
            showSelection: true,
            showSkipButton: false,
          );
  }
}
