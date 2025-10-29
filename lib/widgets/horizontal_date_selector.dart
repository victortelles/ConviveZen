import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../providers/app_state.dart';

class HorizontalDateSelector extends StatelessWidget {
  final AppState appState;

  const HorizontalDateSelector({Key? key, required this.appState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 30, //Mostrar cantidad de dias
        itemBuilder: (context, index) {
          DateTime date = DateTime.now().add(Duration(days: index - 2)); // Día central es el actual
          bool isSelected = index == 2; // El día actual (central y remarcado)

          return Container(
            width: 50,
            margin: EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.blue.shade900
                  : (appState.isDarkMode ? Colors.grey.shade800 : Colors.white),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('E').format(date),
                  style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : (appState.isDarkMode
                              ? Colors.white
                              : Colors.black)),
                ),
                Text(
                  "${date.day}",
                  style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : (appState.isDarkMode
                              ? Colors.white
                              : Colors.black)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
