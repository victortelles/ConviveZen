import 'package:cloud_firestore/cloud_firestore.dart';

// User preferences model for hobbies, affirmations, favorite tools, and help preferences
class UserPreferences {
  // Hobbies and interests
  final List<String> hobbies;
  final List<String> musicGenres;
  final List<String> gameTypes; // 'puzzle', 'arcade', 'strategy', 'relaxing'

  // Affirmations and motivational content
  final List<String> personalAffirmations; // Custom affirmations
  final List<String> favoriteQuotes;
  final String preferredTone; // 'encouraging', 'calming', 'motivational', 'gentle'

  // Emergency tools preferences
  final List<String> favoriteTools; // 'music', 'games', 'breathing', 'meditation', 'chat', 'contacts'
  final String primaryTool; // Main tool to show first
  final bool enableAIChat;
  final bool autoContactEmergency; // Auto-notify emergency contacts

  // Help preferences
  final String helpStyle; // 'guided', 'self_directed', 'mixed'
  final bool preferVisual; // Prefers visual content
  final bool preferAudio; // Prefers audio content
  final bool enableNotifications;
  final int sessionDuration; // Preferred session length in minutes

  // Metadata
  final DateTime? lastUpdated;
  final bool isOnboardingComplete;

  UserPreferences({
    List<String>? hobbies,
    List<String>? musicGenres,
    List<String>? gameTypes,
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
        personalAffirmations = personalAffirmations ?? [],
        favoriteQuotes = favoriteQuotes ?? [],
        favoriteTools = favoriteTools ?? [];

  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    return UserPreferences(
      hobbies: List<String>.from(map['hobbies'] ?? []),
      musicGenres: List<String>.from(map['musicGenres'] ?? []),
      gameTypes: List<String>.from(map['gameTypes'] ?? []),
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

  Map<String, dynamic> toMap() {
    return {
      'hobbies': hobbies,
      'musicGenres': musicGenres,
      'gameTypes': gameTypes,
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

  UserPreferences copyWith({
    List<String>? hobbies,
    List<String>? musicGenres,
    List<String>? gameTypes,
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

  UserPreferences completeOnboarding() {
    return copyWith(
      isOnboardingComplete: true,
      lastUpdated: DateTime.now(),
    );
  }
}
