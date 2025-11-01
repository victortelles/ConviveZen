import 'package:cloud_firestore/cloud_firestore.dart';

// Crisis log model to track emergency button usage and outcomes
class CrisisLog {
  final String id;
  final String userId;
  final DateTime startTime;
  final DateTime? endTime;
  final int anxietyLevelBefore; // 1-10 scale before using emergency button
  final int? anxietyLevelAfter; // 1-10 scale after using tools
  final String triggerType; // Que desató la crisis de ansiedad
  final List<String> toolsUsed; // Que herramientas fueron accedidas
  final String? primaryToolUsed; // Herramienta principal que ayudó
  final int sessionDuration; // Tiempo total pasado en modo de crisis (minutos)
  final String? userNotes; // Notas opcionales del usuario
  final bool wasHelpful; // Si la sesión fue útil
  final bool contactedEmergency; // Si se notificaron contactos de emergencia
  final Map<String, dynamic> metadata; // Additional session data

  CrisisLog({
    required this.id,
    required this.userId,
    DateTime? startTime,
    this.endTime,
    required this.anxietyLevelBefore,
    this.anxietyLevelAfter,
    required this.triggerType,
    List<String>? toolsUsed,
    this.primaryToolUsed,
    this.sessionDuration = 0,
    this.userNotes,
    this.wasHelpful = false,
    this.contactedEmergency = false,
    Map<String, dynamic>? metadata,
  })  : this.startTime = startTime ?? DateTime.now(),
        this.toolsUsed = toolsUsed ?? [],
        this.metadata = metadata ?? {};

  factory CrisisLog.fromMap(Map<String, dynamic> map) {
    return CrisisLog(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      startTime: map['startTime'] != null
          ? (map['startTime'] is Timestamp
              ? (map['startTime'] as Timestamp).toDate()
              : DateTime.parse(map['startTime']))
          : DateTime.now(),
      endTime: map['endTime'] != null
          ? (map['endTime'] is Timestamp
              ? (map['endTime'] as Timestamp).toDate()
              : DateTime.parse(map['endTime']))
          : null,
      anxietyLevelBefore: map['anxietyLevelBefore'] ?? 5,
      anxietyLevelAfter: map['anxietyLevelAfter'],
      triggerType: map['triggerType'] ?? 'unknown',
      toolsUsed: List<String>.from(map['toolsUsed'] ?? []),
      primaryToolUsed: map['primaryToolUsed'],
      sessionDuration: map['sessionDuration'] ?? 0,
      userNotes: map['userNotes'],
      wasHelpful: map['wasHelpful'] ?? false,
      contactedEmergency: map['contactedEmergency'] ?? false,
      metadata: Map<String, dynamic>.from(map['metadata'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': endTime != null ? Timestamp.fromDate(endTime!) : null,
      'anxietyLevelBefore': anxietyLevelBefore,
      'anxietyLevelAfter': anxietyLevelAfter,
      'triggerType': triggerType,
      'toolsUsed': toolsUsed,
      'primaryToolUsed': primaryToolUsed,
      'sessionDuration': sessionDuration,
      'userNotes': userNotes,
      'wasHelpful': wasHelpful,
      'contactedEmergency': contactedEmergency,
      'metadata': metadata,
    };
  }

  CrisisLog copyWith({
    DateTime? endTime,
    int? anxietyLevelAfter,
    List<String>? toolsUsed,
    String? primaryToolUsed,
    int? sessionDuration,
    String? userNotes,
    bool? wasHelpful,
    bool? contactedEmergency,
    Map<String, dynamic>? metadata,
  }) {
    return CrisisLog(
      id: this.id,
      userId: this.userId,
      startTime: this.startTime,
      endTime: endTime ?? this.endTime,
      anxietyLevelBefore: this.anxietyLevelBefore,
      anxietyLevelAfter: anxietyLevelAfter ?? this.anxietyLevelAfter,
      triggerType: this.triggerType,
      toolsUsed: toolsUsed ?? this.toolsUsed,
      primaryToolUsed: primaryToolUsed ?? this.primaryToolUsed,
      sessionDuration: sessionDuration ?? this.sessionDuration,
      userNotes: userNotes ?? this.userNotes,
      wasHelpful: wasHelpful ?? this.wasHelpful,
      contactedEmergency: contactedEmergency ?? this.contactedEmergency,
      metadata: metadata ?? this.metadata,
    );
  }

  // Complete the crisis session
  CrisisLog completeSession({
    required int anxietyLevelAfter,
    String? primaryToolUsed,
    String? userNotes,
    bool wasHelpful = false,
    Map<String, dynamic>? additionalMetadata,
  }) {
    final now = DateTime.now();
    final duration = now.difference(startTime).inMinutes;

    Map<String, dynamic> updatedMetadata = Map.from(metadata);
    if (additionalMetadata != null) {
      updatedMetadata.addAll(additionalMetadata);
    }

    return copyWith(
      endTime: now,
      anxietyLevelAfter: anxietyLevelAfter.clamp(1, 10),
      primaryToolUsed: primaryToolUsed,
      sessionDuration: duration,
      userNotes: userNotes,
      wasHelpful: wasHelpful,
      metadata: updatedMetadata,
    );
  }

  // Add a tool to the used tools list
  CrisisLog addToolUsed(String toolType) {
    final newToolsUsed = List<String>.from(toolsUsed);
    if (!newToolsUsed.contains(toolType)) {
      newToolsUsed.add(toolType);
    }
    return copyWith(toolsUsed: newToolsUsed);
  }

  // Calculate improvement in anxiety level
  int? get anxietyImprovement {
    if (anxietyLevelAfter == null) return null;
    return anxietyLevelBefore - anxietyLevelAfter!;
  }

  // Check if the session was effective
  bool get wasEffective {
    final improvement = anxietyImprovement;
    return improvement != null && improvement > 0;
  }

  // Get session status
  String get status {
    if (endTime == null) return 'active';
    if (wasEffective) return 'effective';
    if (wasHelpful) return 'helpful';
    return 'completed';
  }

  // Common trigger types
  static const List<String> commonTriggers = [
    'social_situation',
    'work_stress',
    'health_concern',
    'relationship_issue',
    'financial_worry',
    'unknown',
    'other',
  ];
}
