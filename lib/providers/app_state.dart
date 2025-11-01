import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../models/user_preferences.dart';
import '../models/user.dart';
import '../services/firebase.dart';

class AppState with ChangeNotifier {
  bool _isDarkMode = false;
  Map<String, bool> _habitStatus = {
    // 'Pasear al perro': false,
    // 'Regar las plantas': false,
    // 'Tender la cama': false,
    // 'Ir al gym': false,
    // 'Lectura diaria': false,
  };

  int notEditableLength = 0;
  // Autenticación y Firestore
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  // Estado de autenticación
  User? _currentUser;
  UserModel? _userProfile;
  bool _isLoading = false;

  AppState() {
    _init();
  }

  void _init() {
    // Escuchar cambios en la autenticación
    _auth.authStateChanges().listen((User? user) {
      _currentUser = user;
      if (user != null) {
        _loadUserProfile();
      } else {
        _userProfile = null;
      }
      notifyListeners();
    });
  }

  // Cargar perfil de usuario de Firestore
  Future<void> _loadUserProfile() async {
    if (_currentUser == null) return;
    print("user id${_currentUser!.uid}");
    setLoading(true);
    try {
      _userProfile = await _firestoreService.getUserById(_currentUser!.uid);
      notifyListeners();
    } catch (e) {
      print('Error loading user profile: $e');
    } finally {
      setLoading(false);
    }
  }

  // Gestores de Estado
  bool get isDarkMode => _isDarkMode;
  Map<String, bool> get habitStatus => _habitStatus;
  User? get currentUser => _currentUser;
  UserModel? get userProfile => _userProfile;
  bool get isLoading => _isLoading;

  // Métodos para actualizar el estado
  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // Método para actualizar el estado de un hábito
  void updateHabit(String habit, bool status) {
    if (_habitStatus.containsKey(habit)) {
      _habitStatus[habit] = status;
      notifyListeners();
    }
  }

  // Método para establecer el estado de carga
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Métodos de autenticación (Cerrar sesion)
  Future<void> signOut() async {
    await _auth.signOut();
    _userProfile = null;
    notifyListeners();
  }

  // Método para guardar un usuario nuevo en Firestore
  Future<void> saveUserToFirestore(UserModel user) async {
    try {
      await _firestoreService.createUser(user);
      _userProfile = user;
      notifyListeners();
    } catch (e) {
      print('Error saving user to Firestore: $e');
      throw e;
    }
  }

  // Método para actualizar las preferencias del usuario
  Future<void> updateUserPreferences({
    String? gender,
    List<String>? habits,
    List<String>? sports,
    List<String>? exerciseTypes,
    List<String>? trainingDays,
  }) async {
    if (_currentUser == null) return;

    setLoading(true);
    try {
      await _firestoreService.saveUserPreferences(
        uid: _currentUser!.uid,
        gender: gender,
        habits: habits,
        sports: sports,
        exerciseTypes: exerciseTypes,
        trainingDays: trainingDays,
      );

      // Recargar el perfil para reflejar los cambios
      await _loadUserProfile();
    } catch (e) {
      print('Error updating user preferences: $e');
      throw e;
    } finally {
      setLoading(false);
    }
  }

  //Metodo para elimianr cuenta
  Future<void> deleteUserAccount() async {
    if (_currentUser == null) throw Exception("No hay usuario autenticado.");

    setLoading(true);

    try {
      //Eliminar usuario en DB (Firestore)
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .delete();

      //Eliminar datos de la DB si el usuario es eliminado
      await FirebaseFirestore.instance
          .collection('userCreatedHabits')
          .doc(currentUser!.uid)
          .delete();

      //Eliminar cuenta en Auth (Firebase)
      await _currentUser!.delete();

      //Limpiar estado
      _userProfile = null;
      _currentUser = null;

      notifyListeners();
    } catch (error) {
      throw Exception("Error al eliminar la cuenta ${error.toString()}");
    } finally {
      setLoading(false);
    }
  }

  //Metodo para Obtener todas las preferencias del usuario
  Future<UserPreferences> getUserPreferences() async {
    if (_currentUser == null) return UserPreferences();

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
        return UserPreferences.fromMap(data ?? {});
      }
      return UserPreferences(); //Retorna una instancia por defecto si no existe
    } catch (e) {
      print("Error al obtener las preferencias del usuario: $e");
      return UserPreferences(); //Retorna una instancia por defecto en caso de error
    }
  }

  // Método para actualizar la imagen de perfil del usuario
  Future<void> updateProfileImage(String imageUrl) async {
    if (_currentUser == null || _userProfile == null) return;

    setLoading(true);
    try {
      // 1. Actualizar el modelo de usuario localmente
      final updatedUser = _userProfile!.copyWith(profilePic: imageUrl);
      _userProfile = updatedUser;

      // 2. Guardar la actualización en Firestore
      await _firestoreService.updateUserProfile(updatedUser);

      notifyListeners();
    } catch (e) {
      print('Error updating profile image: $e');
      // mostrar un mensaje de error al usuario
    } finally {
      setLoading(false);
    }
  }

  //GET | Metodo para Obtener Habitos
  Future<List<String>> getUserHabits() async {
    if (_currentUser == null) return [];
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
        return (data?['habits'] as List<dynamic>?)?.cast<String>() ?? [];
      }
      return [];
    } catch (e) {
      print("Error obteniendo los habitos del usuario: $e");
      return [];
    }
  }

  //GET | Obtener hábitos creados por el usuario
  Future<List<Map<String, dynamic>>> getUserCreatedHabits() async {
    if (_currentUser == null) {
      return [];
    }

    List<String> selectedHabits = await getUserHabits();
    List<dynamic> selectedSports = [];
    List<dynamic> selectedExercises = [];

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
      .collection('users')
      .doc(_currentUser!.uid)
      .get();

    if (userDoc.exists && userDoc.data() != null) {
      Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
      selectedSports = (data?['sports'] as List<dynamic>?)?.cast<String>() ?? [];
      selectedExercises = (data?['excersice_types'] as List<dynamic>?)?.cast<String>() ?? [];
    }

    List<dynamic> tmpList = selectedHabits;
    tmpList += selectedSports + selectedExercises;
    final int defaultHabitsLength = tmpList.length;
    notEditableLength = defaultHabitsLength;

    try {
      DocumentSnapshot userHabitDoc = await FirebaseFirestore.instance
          .collection('userCreatedHabits')
          .doc(_currentUser!.uid)
          .get();

      if (userHabitDoc.exists && userHabitDoc.data() != null) {
        Map<String, dynamic>? data =
            userHabitDoc.data() as Map<String, dynamic>?;

        final List<Map<String, dynamic>> habits =
            (data?['created_habits'] as List<dynamic>?)?.map((habit) {
                  if (habit is Map<String, dynamic>) {
                    return {
                      'title': habit['title'] ?? '',
                      'days': List<String>.from(habit['days'] ?? []),
                    };
                  } else {
                    return {'title': '', 'days': []};
                  }
                }).toList() ??
                [];
        //tmpList += habits;

        
        _habitStatus = {
          for (var title in [
            ...tmpList,
            ...habits.map((h) => h['title'] as String)
          ])
            title: false
        }; 
        print(tmpList);
        notifyListeners();
        final String currentDay = DateFormat('EEEE').format(DateTime.now()); 
        final List<Map<String, dynamic>> defaultHabitsWithCurrentDay =
          tmpList.map((title) => {
            'title': title,
            'days': [currentDay],
          }).toList();
        return [
          ...defaultHabitsWithCurrentDay,
          ...habits
        ];
      } else {
        print("No habit document exists for user.");
        _habitStatus = {
          for (var habit in tmpList) habit: false
        };
        notifyListeners();
        print(tmpList);

        final String currentDay = DateFormat('EEEE').format(DateTime.now());
        final List<Map<String, dynamic>> defaultHabitsWithCurrentDay =
            tmpList.map((title) => {
              'title': title,
              'days': [currentDay],
            }).toList();

        return defaultHabitsWithCurrentDay;
      }
    } catch (e) {
      print("Error obteniendo los hábitos creados por el usuario: $e");
      return [];
    }
  }

  //CREATE | Funcionalidad para agregar Habitos al usuario
  Future<void> addUserHabit(String habit, List<String> selectedDays) async {
    if (_currentUser == null) return;

    final docRef = FirebaseFirestore.instance
        .collection('userCreatedHabits')
        .doc(_currentUser!.uid);

    try {
      final doc = await docRef.get();

      if (doc.exists) {
        List<dynamic> habits = doc.data()?['created_habits'] ?? [];
        if (!habits.any((h) => h['title'] == habit)) {
          habits.add({'title': habit, 'days': selectedDays});
          await docRef.update({'created_habits': habits});
        }
      } else {
        await docRef.set({
          'userId': _currentUser!.uid,
          'created_habits': [
            {'title': habit, 'days': selectedDays}
          ]
        });
      }

      _habitStatus[habit] = false;
      notifyListeners();
    } catch (e) {
      print("Error adding habit: $e");
    }
  }

  //PUT | Funcionalidad para actualizar un hábito de usuario
  Future<void> updateUserHabit(
      {String? newHabitName,
      String? oldHabitName,
      List<String>? selectedDays}) async {
    if (_currentUser == null) return;

    final docRef = FirebaseFirestore.instance
        .collection('userCreatedHabits')
        .doc(_currentUser!.uid);

    try {
      final doc = await docRef.get();

      if (doc.exists) {
        List<dynamic> habits = doc.data()?['created_habits'] ?? [];
        for (int i = 0; i < habits.length; i++) {
          if (habits[i]['title'] == oldHabitName) {
            habits[i] = {
              'title': newHabitName ?? habits[i]['title'],
              'days': selectedDays ?? habits[i]['days'],
            };
          }
        }
        await docRef.update({'created_habits': habits});
      }
    } catch (e) {
      print("Error actualizando el hábito: $e");
    }
  }

  //DELETE | Funcionalidad para eliminar hábitos del usuario
  Future<void> deleteUserHabit(String habitTitle) async {
    if (_currentUser == null) return;

    final docRef = FirebaseFirestore.instance
        .collection('userCreatedHabits')
        .doc(_currentUser!.uid);
    try {
      final doc = await docRef.get();

      if (doc.exists) {
        List<dynamic> habits = doc.data()?['created_habits'] ?? [];
        habits.removeWhere((habit) => habit['title'] == habitTitle);
        await docRef.update({'created_habits': habits});
      }
    } catch (e) {
      print("Error eliminando el hábito: $e");
    }
  }

  // Guardar preferencias de usuario en Firestore
  Future<void> saveUserPreferencesToFirestore(UserPreferences preferences) async {
    if (_currentUser == null) return;

    setLoading(true);
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .collection('preferences')
          .doc('main')
          .set(preferences.toMap());
      
      print('User preferences saved successfully');
    } catch (e) {
      print('Error saving user preferences: $e');
      throw e;
    } finally {
      setLoading(false);
    }
  }

  // Agregar eventos

  final List<Event> _eventos = [];

  List<Event> get eventos => List.unmodifiable(_eventos);

  void agregarEvento(Event evento) {
    _eventos.add(evento);
    notifyListeners();
  }
}

class Event {
  final String summary;
  final String location;
  final DateTime start;

  Event({required this.summary, required this.location, required this.start});
}
