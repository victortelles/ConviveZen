import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';

class HabitsList extends StatefulWidget {
  const HabitsList({super.key});

  @override
  State<HabitsList> createState() => _HabitsListState();
}

class _HabitsListState extends State<HabitsList> {
  List<Map<String, dynamic>> _createdHabits = [];
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final appState = Provider.of<AppState>(context);

    if (!_loaded && appState.currentUser != null) {
      _loaded = true;
      _loadUserCreatedHabits(appState);
    }
  }

  //Leer los habitos creados por el usuario
  Future<void> _loadUserCreatedHabits(AppState appState) async {
    try {
      print("Fetching habits for: ${appState.currentUser}");
      final userCreatedHabits = await appState.getUserCreatedHabits();

      // Validar que los datos sean del tipo esperado
      if (userCreatedHabits is List<Map<String, dynamic>>) {
        setState(() {
          _createdHabits = userCreatedHabits;
          print("Habits: $_createdHabits");
        });
      } else {
        throw Exception("Los datos de hábitos no son del tipo esperado.");
      }
    } catch (e) {
      print('Error loading habits: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Error al cargar los hábitos: ${e.toString()}")),
        );
      }
    }
  }

  // boton _showAddHabitDialog para añadir hábitos
  void _showAddHabitDialog(BuildContext context) {
    String newHabit = '';
    List<String> selectedDays = [];
    List<String> daysOfWeek = [
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday"
    ];

    final appState = Provider.of<AppState>(context, listen: false);
    Color dialogBackgroundColor =
        appState.isDarkMode ? Colors.grey.shade900 : Colors.white;
    Color textColor = appState.isDarkMode ? Colors.white : Colors.black;
    Color positiveButtonColor = Colors.blue.shade700;
    Color negativeButtonColor = Colors.red.shade700;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Agregar nuevo hábito',
                  style: TextStyle(color: textColor)),
              backgroundColor: dialogBackgroundColor,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) => newHabit = value,
                    decoration: InputDecoration(
                      hintText: 'Ej. Leer 10 min',
                      hintStyle: TextStyle(color: textColor.withOpacity(0.7)),
                    ),
                    style: TextStyle(color: textColor),
                  ),
                  SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Selecciona los días',
                        style: TextStyle(color: textColor)),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 12.0,
                    runSpacing: 12.0,
                    children: daysOfWeek.map((day) {
                      final isSelected = selectedDays.contains(day);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedDays.remove(day);
                            } else {
                              selectedDays.add(day);
                            }
                          });
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color:
                                isSelected ? Colors.blue.shade800 : Colors.grey,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            day.substring(0, 3),
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar',
                      style: TextStyle(color: negativeButtonColor)),
                ),
                TextButton(
                  onPressed: () async {
                     _loadUserCreatedHabits(appState);
                    if (newHabit.trim().isEmpty || selectedDays.isEmpty) return;

                    await appState.addUserHabit(newHabit.trim(), selectedDays);
                    Navigator.pop(context);
                    setState(() {});

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Hábito "$newHabit" creado con éxito.'),
                      ),
                    );
                  },
                  child: Text('Crear',
                      style: TextStyle(color: positiveButtonColor)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //Declaracion de variables
    final appState = Provider.of<AppState>(context);
    print("Build user: ${appState.currentUser}");

    // Obtener el día actual
    String today = [
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday"
    ][DateTime.now().weekday % 7];

    // Filtrar los hábitos por el día actual
    List<Map<String, dynamic>> filteredHabits =
        _createdHabits.where((habit) => habit['days'].contains(today)).toList();

    // Actualización del diálogo de actualización de hábito
    void showUpdateDialog(
        BuildContext context, Map<String, dynamic> currentHabit) {
      String newHabitName = currentHabit['title'];
      List<String> selectedDays = List<String>.from(currentHabit['days']);
      List<String> daysOfWeek = [
        "Sunday",
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday"
      ];

      //Declarar colores
      final appState = Provider.of<AppState>(context, listen: false);
      Color dialogBackgroundColor = appState.isDarkMode ? Colors.grey.shade900 : Colors.white;
      Color textColor = appState.isDarkMode ? Colors.white : Colors.black;
      Color positiveButtonColor = Colors.blue.shade700;
      Color negativeButtonColor = Colors.red.shade700;
      Color selectedDayColor = appState.isDarkMode ? Colors.blue.shade800 : Colors.blue.shade900;

      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text('Actualizar hábito',
                    style: TextStyle(color: textColor)),
                backgroundColor: dialogBackgroundColor,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      initialValue: newHabitName,
                      onChanged: (value) => newHabitName = value,
                      decoration: InputDecoration(
                        hintText: 'Ej. Leer 10 min',
                        hintStyle: TextStyle(color: textColor.withOpacity(0.7)),
                      ),
                      style: TextStyle(color: textColor),
                    ),
                    SizedBox(height: 16),
                    Wrap(
                      spacing: 12.0,
                      runSpacing: 12.0,
                      children: daysOfWeek.map((day) {
                        final isSelected = selectedDays.contains(day);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selectedDays.remove(day);
                              } else {
                                selectedDays.add(day);
                              }
                            });
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color:
                                  isSelected ? selectedDayColor : Colors.grey,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              day.substring(0, 3),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancelar',
                        style: TextStyle(color: negativeButtonColor)),
                  ),
                  TextButton(
                    onPressed: () async {
                      bool hasTitleChanged =
                          newHabitName.trim() != currentHabit['title'];
                      bool haveDaysChanged = !Set.from(selectedDays)
                              .containsAll(currentHabit['days']) ||
                          !Set.from(currentHabit['days'])
                              .containsAll(selectedDays);
                      if (!hasTitleChanged && !haveDaysChanged) {
                        Navigator.pop(context);
                        return;
                      }

                      await appState.updateUserHabit(
                        newHabitName:
                            hasTitleChanged ? newHabitName.trim() : null,
                        oldHabitName: currentHabit['title'],
                        selectedDays: haveDaysChanged ? selectedDays : null,
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Hábito actualizado: $newHabitName')),
                      );
                      _loadUserCreatedHabits(appState);
                    },
                    child: Text('Actualizar',
                        style: TextStyle(color: positiveButtonColor)),
                  ),
                ],
              );
            },
          );
        },
      );
    }

    //Dialogo para mostrar el eliminar habito
    void showDeleteDialog(BuildContext context, currentHabit) {
      //Declarar colores
      final appState = Provider.of<AppState>(context, listen: false);
      Color dialogBackgroundColor = appState.isDarkMode ? Colors.grey.shade900 : Colors.white;
      Color textColor = appState.isDarkMode ? Colors.white : Colors.black;
      Color positiveButtonColor = Colors.blue.shade700;
      Color negativeButtonColor = Colors.red.shade700;

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              '¿Estás seguro de que quieres eliminar este hábito?',
              style: TextStyle(color: textColor),
            ),
            backgroundColor: dialogBackgroundColor,
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'No',
                  style: TextStyle(color: negativeButtonColor),
                ),
              ),
              TextButton(
                onPressed: () async {
                  await appState.deleteUserHabit(currentHabit);
                  Navigator.pop(context);
                  _loadUserCreatedHabits(appState);
                  setState(() {});

                  // Mostrar un SnackBar al eliminar un hábito
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Hábito "$currentHabit" eliminado con éxito.'),
                    ),
                  );
                },
                child: Text(
                  'Sí',
                  style: TextStyle(color: positiveButtonColor),
                ),
              ),
            ],
          );
        },
      );
    }

    // Añadir RefreshIndicator para Swipe Down
    return Scaffold(
      backgroundColor: appState.isDarkMode ? Colors.black : Colors.grey[200],
      body: RefreshIndicator(
        onRefresh: () => _loadUserCreatedHabits(appState),
        child: ListView(
  children: filteredHabits.asMap().entries.map((entry) {
    final index = entry.key;
    final habit = entry.value;
    final habitTitle = habit['title'];
    final isSelected = appState.habitStatus[habitTitle] ?? false;

    final isEditable = index >= appState.notEditableLength;

    return GestureDetector(
      onTap: () {
        appState.updateHabit(habitTitle, !isSelected);
      },
      child: Card(
        color: appState.isDarkMode
            ? Colors.grey.shade800
            : Colors.grey.shade300,
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                habitTitle,
                style: TextStyle(
                  color: appState.isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                habit['days']
                    .map((day) => day.substring(0, 3))
                    .join(', '),
                style: TextStyle(
                  color: appState.isDarkMode
                      ? Colors.white70
                      : Colors.black54,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          leading: Icon(
            Icons.check_circle,
            color: isSelected ? Color(0xFF0046A1) : Colors.grey,
          ),
          trailing: isEditable
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        showUpdateDialog(context, habit);
                      },
                      icon: Icon(
                        Icons.edit,
                        color: appState.isDarkMode ? Colors.blue : Colors.blue,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showDeleteDialog(context, habitTitle);
                      },
                      icon: Icon(
                        Icons.delete,
                        color: appState.isDarkMode ? Colors.red : Colors.red,
                      ),
                    ),
                  ],
                )
              : null,
              ),
            ),
          );
        }).toList(),
      ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddHabitDialog(context),
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
