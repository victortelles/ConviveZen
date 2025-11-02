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
          .collection('preferences')
          .doc('main')
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

  // Método para actualizar tipos de ansiedad en el perfil del usuario
  Future<void> updateAnxietyTypes(List<String> anxietyTypes) async {
    if (_currentUser == null || _userProfile == null) return;

    setLoading(true);
    try {
      await _firestoreService.updateUser(_currentUser!.uid, {
        'anxietyTypes': anxietyTypes,
      });

      // Actualizar el perfil local
      _userProfile = UserModel(
        uid: _userProfile!.uid,
        email: _userProfile!.email,
        name: _userProfile!.name,
        profilePic: _userProfile!.profilePic,
        authProvider: _userProfile!.authProvider,
        isActive: _userProfile!.isActive,
        isFirstTime: _userProfile!.isFirstTime,
        createdAt: _userProfile!.createdAt,
        birthdate: _userProfile!.birthdate,
        anxietyTypes: anxietyTypes,
        anxietyLevel: _userProfile!.anxietyLevel,
        personalityType: _userProfile!.personalityType,
        triggers: _userProfile!.triggers,
        hasSubscription: _userProfile!.hasSubscription,
        subscriptionExpiry: _userProfile!.subscriptionExpiry,
      );

      notifyListeners();
    } catch (e) {
      print('Error updating anxiety types: $e');
      throw e;
    } finally {
      setLoading(false);
    }
  }

  // Método para actualizar géneros musicales
  Future<void> updateMusicGenres(List<String> musicGenres) async {
    if (_currentUser == null) return;

    setLoading(true);
    try {
      UserPreferences currentPrefs = await getUserPreferences();
      UserPreferences updatedPrefs = currentPrefs.copyWith(
        musicGenres: musicGenres,
        lastUpdated: DateTime.now(),
      );

      await saveUserPreferencesToFirestore(updatedPrefs);
    } catch (e) {
      print('Error updating music genres: $e');
      throw e;
    } finally {
      setLoading(false);
    }
  }

  // Método para actualizar hobbies
  Future<void> updateHobbies(List<String> hobbies) async {
    if (_currentUser == null) return;

    setLoading(true);
    try {
      UserPreferences currentPrefs = await getUserPreferences();
      UserPreferences updatedPrefs = currentPrefs.copyWith(
        hobbies: hobbies,
        lastUpdated: DateTime.now(),
      );

      await saveUserPreferencesToFirestore(updatedPrefs);
    } catch (e) {
      print('Error updating hobbies: $e');
      throw e;
    } finally {
      setLoading(false);
    }
  }

  // Método para actualizar estilo de ayuda
  Future<void> updateHelpStyle(String helpStyle) async {
    if (_currentUser == null) return;

    setLoading(true);
    try {
      UserPreferences currentPrefs = await getUserPreferences();
      UserPreferences updatedPrefs = currentPrefs.copyWith(
        helpStyle: helpStyle,
        lastUpdated: DateTime.now(),
      );

      await saveUserPreferencesToFirestore(updatedPrefs);
    } catch (e) {
      print('Error updating help style: $e');
      throw e;
    } finally {
      setLoading(false);
    }
  }

  // Método para actualizar triggers
  Future<void> updateTriggers(List<String> triggers) async {
    if (_currentUser == null) return;

    setLoading(true);
    try {
      UserPreferences currentPrefs = await getUserPreferences();
      UserPreferences updatedPrefs = currentPrefs.copyWith(
        triggers: triggers,
        lastUpdated: DateTime.now(),
      );

      await saveUserPreferencesToFirestore(updatedPrefs);
    } catch (e) {
      print('Error updating triggers: $e');
      throw e;
    } finally {
      setLoading(false);
    }
  }

  // Método para actualizar tipo de personalidad
  Future<void> updatePersonalityType(String personalityType) async {
    if (_currentUser == null) return;

    setLoading(true);
    try {
      UserPreferences currentPrefs = await getUserPreferences();
      UserPreferences updatedPrefs = currentPrefs.copyWith(
        personalityType: personalityType,
        lastUpdated: DateTime.now(),
      );

      await saveUserPreferencesToFirestore(updatedPrefs);
    } catch (e) {
      print('Error updating personality type: $e');
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
