import 'package:cloud_firestore/cloud_firestore.dart';

// Modelo para registro de actividades de intervención en ansiedad
class AnxietySession {
  final String id;
  final String userId;
  final String type; // 'breathing', 'meditation', 'exercise', 'journal', 'emergency'
  final String title;
  final String? description;
  final int duration; // en minutos
  final int anxietyBefore; // 1-10 escala antes de la sesión
  final int anxietyAfter; // 1-10 escala después de la sesión
  final List<String> techniques; // Técnicas utilizadas
  final Map<String, dynamic> sessionData; // Datos específicos de la sesión
  final DateTime startTime;
  final DateTime? endTime;
  final bool isCompleted;
  final String? notes; // Notas del usuario

  AnxietySession({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    this.description,
    this.duration = 0,
    this.anxietyBefore = 5,
    this.anxietyAfter = 5,
    List<String>? techniques,
    Map<String, dynamic>? sessionData,
    DateTime? startTime,
    this.endTime,
    this.isCompleted = false,
    this.notes,
  }) : techniques = techniques ?? [],
       sessionData = sessionData ?? {},
       startTime = startTime ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'title': title,
      'description': description,
      'duration': duration,
      'anxietyBefore': anxietyBefore,
      'anxietyAfter': anxietyAfter,
      'techniques': techniques,
      'sessionData': sessionData,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': endTime != null ? Timestamp.fromDate(endTime!) : null,
      'isCompleted': isCompleted,
      'notes': notes,
    };
  }

  factory AnxietySession.fromMap(Map<String, dynamic> map) {
    return AnxietySession(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      type: map['type'] ?? 'breathing',
      title: map['title'] ?? '',
      description: map['description'],
      duration: map['duration'] ?? 0,
      anxietyBefore: map['anxietyBefore'] ?? 5,
      anxietyAfter: map['anxietyAfter'] ?? 5,
      techniques: List<String>.from(map['techniques'] ?? []),
      sessionData: Map<String, dynamic>.from(map['sessionData'] ?? {}),
      startTime: map['startTime'] != null ? (map['startTime'] as Timestamp).toDate() : DateTime.now(),
      endTime: map['endTime'] != null ? (map['endTime'] as Timestamp).toDate() : null,
      isCompleted: map['isCompleted'] ?? false,
      notes: map['notes'],
    );
  }

  AnxietySession copyWith({
    String? type,
    String? title,
    String? description,
    int? duration,
    int? anxietyBefore,
    int? anxietyAfter,
    List<String>? techniques,
    Map<String, dynamic>? sessionData,
    DateTime? endTime,
    bool? isCompleted,
    String? notes,
  }) {
    return AnxietySession(
      id: this.id,
      userId: this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      anxietyBefore: anxietyBefore ?? this.anxietyBefore,
      anxietyAfter: anxietyAfter ?? this.anxietyAfter,
      techniques: techniques ?? this.techniques,
      sessionData: sessionData ?? this.sessionData,
      startTime: this.startTime,
      endTime: endTime ?? this.endTime,
      isCompleted: isCompleted ?? this.isCompleted,
      notes: notes ?? this.notes,
    );
  }

  // Completar sesión
  AnxietySession complete({
    required int anxietyAfter,
    String? notes,
    Map<String, dynamic>? additionalData,
  }) {
    final now = DateTime.now();
    final sessionDuration = now.difference(startTime).inMinutes;
    
    Map<String, dynamic> updatedSessionData = Map.from(sessionData);
    if (additionalData != null) {
      updatedSessionData.addAll(additionalData);
    }

    return copyWith(
      duration: sessionDuration,
      anxietyAfter: anxietyAfter.clamp(1, 10),
      endTime: now,
      isCompleted: true,
      notes: notes,
      sessionData: updatedSessionData,
    );
  }

  // Calcular mejora en ansiedad
  int get anxietyImprovement => anxietyBefore - anxietyAfter;
  
  // Verificar si la sesión fue efectiva (redujo ansiedad)
  bool get wasEffective => anxietyImprovement > 0;
}

// Modelo para evaluaciones de ansiedad
class AnxietyAssessment {
  final String id;
  final String userId;
  final String assessmentType; // 'GAD-7', 'PHQ-9', 'daily', 'weekly', etc.
  final Map<String, dynamic> responses; // Respuestas del cuestionario
  final int score; // Puntuación total
  final String severity; // 'minimal', 'mild', 'moderate', 'severe'
  final DateTime completedAt;
  final String? recommendations; // Recomendaciones generadas

  AnxietyAssessment({
    required this.id,
    required this.userId,
    required this.assessmentType,
    required this.responses,
    required this.score,
    required this.severity,
    DateTime? completedAt,
    this.recommendations,
  }) : completedAt = completedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'assessmentType': assessmentType,
      'responses': responses,
      'score': score,
      'severity': severity,
      'completedAt': Timestamp.fromDate(completedAt),
      'recommendations': recommendations,
    };
  }

  factory AnxietyAssessment.fromMap(Map<String, dynamic> map) {
    return AnxietyAssessment(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      assessmentType: map['assessmentType'] ?? 'daily',
      responses: Map<String, dynamic>.from(map['responses'] ?? {}),
      score: map['score'] ?? 0,
      severity: map['severity'] ?? 'minimal',
      completedAt: map['completedAt'] != null ? (map['completedAt'] as Timestamp).toDate() : DateTime.now(),
      recommendations: map['recommendations'],
    );
  }
}