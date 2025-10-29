import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/personalization_data.dart';
import '../providers/app_state.dart';
import '../widgets/personalization_page.dart';

class DaysDetail extends StatefulWidget {
  const DaysDetail({Key? key}) : super(key: key);

  @override
  State<DaysDetail> createState() => _DaysDetailState();
}

class _DaysDetailState extends State<DaysDetail> {
  late List<String> _selectedDays = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSelectedDays();
  }

  Future<void> _loadSelectedDays() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final appState = Provider.of<AppState>(context, listen: false);
      final userPreferences = await appState.getUserPreferences();
      setState(() {
        _selectedDays = userPreferences.selectedDays;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cargar los días: ${e.toString()}")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onDaySelected(String day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
    });
  }

  Future<void> _savePreferences() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final appState = Provider.of<AppState>(context, listen: false);

      // Obtener las preferencias de los usuarios
      final userPreferences = await appState.getUserPreferences();
      // Actualizar los habitos seleccionados
      userPreferences.selectedDays = _selectedDays;
      // Guardar las preferencias seleccionadas
      await appState.updateUserPreferences(trainingDays: userPreferences.selectedDays);

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text("Error al guardar las preferencias: ${e.toString()}")),
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
              title: Text("Tus Días", style: TextStyle(color: textColor)),
              backgroundColor: backgroundColor,
              iconTheme: IconThemeData(color: textColor),
            ),
            body: Center(child: CircularProgressIndicator()),
            backgroundColor: backgroundColor,
          )
        : PersonalizationPage(
            title: "Tus Días",
            instructionText: "Selecciona tus días de entrenamiento",
            options: PersonalizationData.dayOptions,
            selectedValues: _selectedDays,
            onOptionSelected: _onDaySelected,
            onNext: _savePreferences,
            backgroundColor: backgroundColor,
            textColor: textColor,
          );
  }
}
