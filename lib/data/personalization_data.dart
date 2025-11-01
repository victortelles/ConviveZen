import 'package:flutter/material.dart';

class PersonalizationData {

  // Genero
  static const List<Map<String, dynamic>> genderOptions = [
    {'name': 'Hombre', 'icon': Icons.male, 'value': 'male'},
    {'name': 'Mujer', 'icon': Icons.female, 'value': 'female'},
  ];

  // NOTA: habitOptions, exerciseOptions y sportOptions fueron removidos 
  // porque no son relevantes para ConviveZen (app de manejo de ansiedad)

  // Días - mantenido para compatibilidad con otras funcionalidades
  static const List<Map<String, dynamic>> dayOptions = [
    {'name': 'Lunes', 'icon': Icons.calendar_today, 'value': 'monday'},
    {'name': 'Martes', 'icon': Icons.calendar_today, 'value': 'tuesday'},
    {'name': 'Miércoles', 'icon': Icons.calendar_today, 'value': 'wednesday'},
    {'name': 'Jueves', 'icon': Icons.calendar_today, 'value': 'thursday'},
    {'name': 'Viernes', 'icon': Icons.calendar_today, 'value': 'friday'},
    {'name': 'Sábado', 'icon': Icons.calendar_today, 'value': 'saturday'},
    {'name': 'Domingo', 'icon': Icons.calendar_today, 'value': 'sunday'},
  ];
}