import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';

class AllHabitsList extends StatefulWidget {
  const AllHabitsList({super.key});

  @override
  State<AllHabitsList> createState() => _AllHabitsListState();
}

class _AllHabitsListState extends State<AllHabitsList> {
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

  //Cargar hábitos creados por el usuario
  Future<void> _loadUserCreatedHabits(AppState appState) async {
    try {
      final userCreatedHabits = await appState.getUserCreatedHabits();

      setState(() {
        _createdHabits = userCreatedHabits;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Error al cargar los hábitos: ${e.toString()}")),
        );
      }
    }
  }

  //Dialogo para actualizar el hábito
  void showUpdateDialog(BuildContext context, Map<String, dynamic> currentHabit) {
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
                            color: isSelected ? selectedDayColor : Colors.grey,
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
                    bool hasTitleChanged = newHabitName.trim() != currentHabit['title'];
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
                  child: Text('Actualizar', style: TextStyle(color: positiveButtonColor)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  //Dialogo para eliminar el hábito
  void showDeleteDialog(BuildContext context, String habitTitle) {
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
                await appState.deleteUserHabit(habitTitle);
                Navigator.pop(context);
                _loadUserCreatedHabits(appState);
                setState(() {});

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Hábito "$habitTitle" eliminado con éxito.'),
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

  //Dialogo para agregar un nuevo hábito
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
                            color: isSelected ? selectedDayColor : Colors.grey,
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
                  child: Text('Crear', style: TextStyle(color: positiveButtonColor)),
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
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2296F3),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Todos tus Hábitos',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      backgroundColor: appState.isDarkMode ? Colors.black : Colors.grey[200],
      body: RefreshIndicator(
        onRefresh: () => _loadUserCreatedHabits(appState),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: _createdHabits.map((habit) {
            final habitTitle = habit['title'];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              color: appState.isDarkMode
                  ? Colors.grey.shade800
                  : Colors.grey.shade300,
              child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Título del hábito
                    Text(
                      habitTitle,
                      maxLines: 2,                      // Limitar a 2 líneas el parrafo
                      overflow: TextOverflow.ellipsis,  // Añadir puntos suspensivos si se pasa
                      style: TextStyle(
                        color:
                            appState.isDarkMode ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 4),

                    //Dias
                    Text(
                      habit['days']
                          .map((day) => day.substring(0, 3))
                          .join(', '),
                      style: TextStyle(
                        color: appState.isDarkMode
                            ? Colors.white70
                            : Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                //Iconos de editar y eliminar
                trailing: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //Icono de editar
                    IconButton(
                      onPressed: () {
                        showUpdateDialog(context, habit);
                      },
                      icon: Icon(
                        Icons.edit,
                        color:
                            appState.isDarkMode ? Colors.blue : Colors.blue,
                      ),
                    ),
                    //Icono de eliminar
                    IconButton(
                      onPressed: () {
                        showDeleteDialog(context, habitTitle);
                      },
                      icon: Icon(
                        Icons.delete,
                        color:
                            appState.isDarkMode ? Colors.red : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddHabitDialog(context),
        backgroundColor: Color(0xFF2296F3),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
