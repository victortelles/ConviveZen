import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_preferences.dart';
import '../models/user.dart';
import '../services/firebase.dart';

class AppState with ChangeNotifier {
  bool _isDarkMode = false;
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
  User? get currentUser => _currentUser;
  UserModel? get userProfile => _userProfile;
  bool get isLoading => _isLoading;

  // Métodos para actualizar el estado
  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
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
  }) async {
    if (_currentUser == null) return;

    setLoading(true);
    try {
      await _firestoreService.saveUserPreferences(
        uid: _currentUser!.uid,
        gender: gender,
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
