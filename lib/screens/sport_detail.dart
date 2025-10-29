import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../data/personalization_data.dart';
import '../widgets/personalization_page.dart';

class SportDetail extends StatefulWidget {
  const SportDetail({Key? key}) : super(key: key);

  @override
  State<SportDetail> createState() => _SportDetailState();
}

class _SportDetailState extends State<SportDetail> {
  List<String> _selectedSports = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserSports();
  }

  // Cargar preferencias del usuario
  Future<void> _loadUserSports() async {
    try {
      final appState = Provider.of<AppState>(context, listen: false);
      final userPreferences = await appState.getUserPreferences();
      setState(() {
        _selectedSports = userPreferences.selectedSports;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading user sports: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Error al cargar los deportes: ${e.toString()}")),
      );
    }
  }

  // Maneja la selección/deselección de un deporte
  void _onSportSelected(String sport) {
    setState(() {
      if (_selectedSports.contains(sport)) {
        _selectedSports.remove(sport);
      } else {
        _selectedSports.add(sport);
      }
    });
  }

  // Guardar preferencias del usuario
  Future<void> _savePreferences() async {
    try {
      final appState = Provider.of<AppState>(context, listen: false);
      await appState.updateUserPreferences(sports: _selectedSports);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Error al actualizar los deportes: ${e.toString()}")),
      );
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
              title: Text("Tus Deportes", style: TextStyle(color: textColor)),
              backgroundColor: backgroundColor,
              iconTheme: IconThemeData(color: textColor),
            ),
            body: Center(child: CircularProgressIndicator()),
            backgroundColor: backgroundColor,
          )
        : PersonalizationPage(
            title: "Tus Deportes",
            instructionText: "Selecciona tus deportes favoritos",
            options: PersonalizationData.sportOptions,
            selectedValues: _selectedSports,
            onOptionSelected: _onSportSelected,
            onNext: _savePreferences,
            backgroundColor: backgroundColor,
            textColor: textColor,
          );
  }
}
