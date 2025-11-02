import 'package:cloud_firestore/cloud_firestore.dart';

// Modelo de preferencias de usuario para personalizar la experiencia
class UserPreferences {
  // Definir atributos
  // Hobbies y intereses
  final List<String> hobbies;
  final List<String> musicGenres;
  final List<String> gameTypes; // 'puzzle', 'arcade', 'strategy', 'relaxing'

  // Datos específicos de ansiedad
  final List<String> triggers; // Principales desencadenantes de ansiedad
  final String? personalityType; // 'introvert', 'extrovert', 'ambivert'

  // Afirmaciones y contenido motivacional
  final List<String> personalAffirmations; // Personalizacion de afirmaciones
  final List<String> favoriteQuotes;
  final String preferredTone; // 'encouraging', 'calming', 'motivational', 'gentle'

  // Preferencia de herramientas de emergencia
  final List<String> favoriteTools; // 'music', 'games', 'breathing', 'meditation', 'chat', 'contacts'
  final String primaryTool; // Main tool to show first
  final bool enableAIChat;
  final bool autoContactEmergency; // Auto-notify emergency contacts

  // Preferencias de ayuda
  final String helpStyle; // 'guided', 'self_directed', 'mixed'
  final bool preferVisual; // Preferencia por contenido visual
  final bool preferAudio; // Preferencia por contenido de audio
  final bool enableNotifications; // habilitar notificaciones de la app
  final int sessionDuration; // Preferencia de duración de sesión en minutos

  // Metadata
  final DateTime? lastUpdated;
  final bool isOnboardingComplete;

  // Constructor
  UserPreferences({
    List<String>? hobbies,
    List<String>? musicGenres,
    List<String>? gameTypes,
    List<String>? triggers,
    this.personalityType,
    List<String>? personalAffirmations,
    List<String>? favoriteQuotes,
    this.preferredTone = 'calming',
    List<String>? favoriteTools,
    this.primaryTool = 'breathing',
    this.enableAIChat = true,
    this.autoContactEmergency = false,
    this.helpStyle = 'guided',
    this.preferVisual = true,
    this.preferAudio = true,
    this.enableNotifications = true,
    this.sessionDuration = 10,
    this.lastUpdated,
    this.isOnboardingComplete = false,
  })  : hobbies = hobbies ?? [],
        musicGenres = musicGenres ?? [],
        gameTypes = gameTypes ?? [],
        triggers = triggers ?? [],
        personalAffirmations = personalAffirmations ?? [],
        favoriteQuotes = favoriteQuotes ?? [],
        favoriteTools = favoriteTools ?? [];

  // Metodo Factory para crear el modelo desde un mapa de Firestore
  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    return UserPreferences(
      hobbies: List<String>.from(map['hobbies'] ?? []),
      musicGenres: List<String>.from(map['musicGenres'] ?? []),
      gameTypes: List<String>.from(map['gameTypes'] ?? []),
      triggers: List<String>.from(map['triggers'] ?? []),
      personalityType: map['personalityType'],
      personalAffirmations:
          List<String>.from(map['personalAffirmations'] ?? []),
      favoriteQuotes: List<String>.from(map['favoriteQuotes'] ?? []),
      preferredTone: map['preferredTone'] ?? 'calming',
      favoriteTools: List<String>.from(map['favoriteTools'] ?? []),
      primaryTool: map['primaryTool'] ?? 'breathing',
      enableAIChat: map['enableAIChat'] ?? true,
      autoContactEmergency: map['autoContactEmergency'] ?? false,
      helpStyle: map['helpStyle'] ?? 'guided',
      preferVisual: map['preferVisual'] ?? true,
      preferAudio: map['preferAudio'] ?? true,
      enableNotifications: map['enableNotifications'] ?? true,
      sessionDuration: map['sessionDuration'] ?? 10,
      lastUpdated: map['lastUpdated'] != null
          ? (map['lastUpdated'] is Timestamp
              ? (map['lastUpdated'] as Timestamp).toDate()
              : DateTime.parse(map['lastUpdated']))
          : null,
      isOnboardingComplete: map['isOnboardingComplete'] ?? false,
    );
  }

  // Convertir el modelo en mapa para Firestore
  Map<String, dynamic> toMap() {
    return {
      'hobbies': hobbies,
      'musicGenres': musicGenres,
      'gameTypes': gameTypes,
      'triggers': triggers,
      'personalityType': personalityType,
      'personalAffirmations': personalAffirmations,
      'favoriteQuotes': favoriteQuotes,
      'preferredTone': preferredTone,
      'favoriteTools': favoriteTools,
      'primaryTool': primaryTool,
      'enableAIChat': enableAIChat,
      'autoContactEmergency': autoContactEmergency,
      'helpStyle': helpStyle,
      'preferVisual': preferVisual,
      'preferAudio': preferAudio,
      'enableNotifications': enableNotifications,
      'sessionDuration': sessionDuration,
      'lastUpdated': lastUpdated != null
          ? Timestamp.fromDate(lastUpdated!)
          : Timestamp.now(),
      'isOnboardingComplete': isOnboardingComplete,
    };
  }

  // Metodo para clonar y actualizar 
  UserPreferences copyWith({
    List<String>? hobbies,
    List<String>? musicGenres,
    List<String>? gameTypes,
    List<String>? triggers,
    String? personalityType,
    List<String>? personalAffirmations,
    List<String>? favoriteQuotes,
    String? preferredTone,
    List<String>? favoriteTools,
    String? primaryTool,
    bool? enableAIChat,
    bool? autoContactEmergency,
    String? helpStyle,
    bool? preferVisual,
    bool? preferAudio,
    bool? enableNotifications,
    int? sessionDuration,
    DateTime? lastUpdated,
    bool? isOnboardingComplete,
  }) {
    return UserPreferences(
      hobbies: hobbies ?? this.hobbies,
      musicGenres: musicGenres ?? this.musicGenres,
      gameTypes: gameTypes ?? this.gameTypes,
      triggers: triggers ?? this.triggers,
      personalityType: personalityType ?? this.personalityType,
      personalAffirmations: personalAffirmations ?? this.personalAffirmations,
      favoriteQuotes: favoriteQuotes ?? this.favoriteQuotes,
      preferredTone: preferredTone ?? this.preferredTone,
      favoriteTools: favoriteTools ?? this.favoriteTools,
      primaryTool: primaryTool ?? this.primaryTool,
      enableAIChat: enableAIChat ?? this.enableAIChat,
      autoContactEmergency: autoContactEmergency ?? this.autoContactEmergency,
      helpStyle: helpStyle ?? this.helpStyle,
      preferVisual: preferVisual ?? this.preferVisual,
      preferAudio: preferAudio ?? this.preferAudio,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      sessionDuration: sessionDuration ?? this.sessionDuration,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isOnboardingComplete: isOnboardingComplete ?? this.isOnboardingComplete,
    );
  }

  // Método para marcar la finalización del onboarding
  UserPreferences completeOnboarding() {
    return copyWith(
      isOnboardingComplete: true,
      lastUpdated: DateTime.now(),
    );
  }
}
