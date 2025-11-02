import 'package:flutter/material.dart';

class OnboardingState extends ChangeNotifier {
  // Definir atributos
  // Current step tracking
  int _currentStep = 0;
  final int totalSteps = 6;

  // User data collection
  List<String> _anxietyTypes = [];
  String? _personalityType;
  List<String> _hobbies = [];
  List<String> _triggers = [];
  List<String> _musicGenres = [];
  String? _helpStyle;

  // Getters
  int get currentStep => _currentStep;
  List<String> get anxietyTypes => _anxietyTypes;
  String? get personalityType => _personalityType;
  List<String> get hobbies => _hobbies;
  List<String> get triggers => _triggers;
  List<String> get musicGenres => _musicGenres;
  String? get helpStyle => _helpStyle;

  bool get canGoBack => _currentStep > 0;
  bool get canGoNext => _currentStep < totalSteps - 1;
  double get progress => (_currentStep + 1) / totalSteps;

  // Navegar entre pasos
  void nextStep() {
    if (canGoNext) {
      _currentStep++;
      notifyListeners();
    }
  }

  // Navegar al paso anterior
  void previousStep() {
    if (canGoBack) {
      _currentStep--;
      notifyListeners();
    }
  }

  // Ir a un paso específico
  void goToStep(int step) {
    if (step >= 0 && step < totalSteps) {
      _currentStep = step;
      notifyListeners();
    }
  }

  // Data setters with persistence
  void setAnxietyTypes(List<String> types) {
    _anxietyTypes = types;
    notifyListeners();
  }

  void setPersonalityType(String type) {
    _personalityType = type;
    notifyListeners();
  }

  void setHobbies(List<String> hobbies) {
    _hobbies = hobbies;
    notifyListeners();
  }

  void setTriggers(List<String> triggers) {
    _triggers = triggers;
    notifyListeners();
  }

  void setMusicGenres(List<String> genres) {
    _musicGenres = genres;
    notifyListeners();
  }

  void setHelpStyle(String style) {
    _helpStyle = style;
    notifyListeners();
  }

  // Reset state
  void reset() {
    _currentStep = 0;
    _anxietyTypes.clear();
    _personalityType = null;
    _hobbies.clear();
    _triggers.clear();
    _musicGenres.clear();
    _helpStyle = null;
    notifyListeners();
  }

  // Validation methods
  bool isStepValid(int step) {
    switch (step) {
      case 0: return _anxietyTypes.isNotEmpty;
      case 1: return _personalityType != null;
      case 2: return _hobbies.isNotEmpty;
      case 3: return _triggers.isNotEmpty;
      case 4: return _musicGenres.isNotEmpty;
      case 5: return _helpStyle != null;
      default: return false;
    }
  }

  bool get isCurrentStepValid => isStepValid(_currentStep);

  // Convertir el modelo en mapa para Firestore
  Map<String, dynamic> toMap() {
    return {
      'anxietyTypes': _anxietyTypes,
      'personalityType': _personalityType,
      'hobbies': _hobbies,
      'triggers': _triggers,
      'musicGenres': _musicGenres,
      'helpStyle': _helpStyle,
    };
  }
}