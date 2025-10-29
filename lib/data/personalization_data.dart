import 'package:flutter/material.dart';

class PersonalizationData {

  // Genero
  static const List<Map<String, dynamic>> genderOptions = [
    {'name': 'Hombre', 'icon': Icons.male, 'value': 'male'},
    {'name': 'Mujer', 'icon': Icons.female, 'value': 'female'},
  ];

  // Hábitos
  static const List<Map<String, dynamic>> habitOptions = [
    {'name': 'Tomar agua', 'icon': Icons.water_drop, 'value': 'Tomar agua'},
    {'name': 'Leer', 'icon': Icons.book, 'value': 'Leer'},
    {'name': 'Meditar', 'icon': Icons.self_improvement, 'value': 'Meditar'},
    {'name': 'Estudio', 'icon': Icons.school, 'value': 'Estudiar'},
    {'name': 'Escritura', 'icon': Icons.edit, 'value': 'Escribir'},
    {'name': 'Dibujo', 'icon': Icons.brush, 'value': 'Dibujar'},
    {'name': 'Dormir', 'icon': Icons.bedtime, 'value': 'Dormir'},
  ];

  // Ejercicios
  static const List<Map<String, dynamic>> exerciseOptions = [
    {'name': 'Correr', 'icon': Icons.directions_run, 'value': 'Correr'},
    {'name': 'Gym', 'icon': Icons.fitness_center, 'value': 'Ir al gym'},
    {'name': 'Gimnasia', 'icon': Icons.sports_gymnastics, 'value': 'Gimnasia'},
    {'name': 'Cross-fit', 'icon': Icons.timer, 'value': 'Crossfit'},
    {'name': 'Yoga', 'icon': Icons.spa, 'value': 'Yoga'},
    {'name': 'Natación', 'icon': Icons.pool, 'value': 'Swimming'},
    {'name': 'Ciclismo', 'icon': Icons.directions_bike, 'value': 'Ciclismo'},
  ];

  // Deportes
  static const List<Map<String, dynamic>> sportOptions = [
    {'name': 'Basquetbol', 'icon': Icons.sports_basketball, 'value': 'Prácticar basquetbol'},
    {'name': 'Soccer', 'icon': Icons.sports_soccer, 'value': 'Prácticar soccer'},
    {'name': 'Volleyball', 'icon': Icons.sports_volleyball, 'value': 'Prácticar volleyball'},
    {'name': 'Tenis', 'icon': Icons.sports_tennis, 'value': 'Prácticar tennis'},
    {'name': 'Béisbol', 'icon': Icons.sports_baseball, 'value': 'Prácticar baseball'},
    {'name': 'Golf', 'icon': Icons.sports_golf, 'value': 'Prácticar golf'},
    {'name': 'Hockey', 'icon': Icons.sports_hockey, 'value': 'Prácticar hockey'},
    {'name': 'Rugby', 'icon': Icons.sports_football, 'value': 'Prácticar rugby'},
    {'name': 'Ping Pong', 'icon': Icons.table_chart, 'value': 'Prácticar pingpong'},
    {'name': 'Boxeo', 'icon': Icons.sports_mma, 'value': 'Prácticar boxing'},
  ];

  // Días
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