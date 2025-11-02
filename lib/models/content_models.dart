import 'package:cloud_firestore/cloud_firestore.dart';

// Modelo para contenido educativo sobre ansiedad y bienestar
class ContentResource {
  // Definicion de atributos
  final String id;
  final String title;
  final String description;
  final String type; // 'article', 'video', 'audio', 'exercise', 'technique'
  final String
      category; // 'breathing', 'meditation', 'cbt', 'mindfulness', etc.
  final String? contentUrl; // URL del contenido multimedia
  final String? textContent; // Contenido de texto
  final int duration; // Duración en minutos (para videos/audios)
  final List<String> tags; // Etiquetas para búsqueda
  final String difficulty; // 'beginner', 'intermediate', 'advanced'
  final bool isPublic;
  final bool isFeatured;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String authorId;
  final Map<String, dynamic> metadata; // Metadatos adicionales

  // Constructor
  ContentResource({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.category,
    this.contentUrl,
    this.textContent,
    this.duration = 0,
    List<String>? tags,
    this.difficulty = 'beginner',
    this.isPublic = true,
    this.isFeatured = false,
    DateTime? createdAt,
    this.updatedAt,
    required this.authorId,
    Map<String, dynamic>? metadata,
  })  : tags = tags ?? [],
        createdAt = createdAt ?? DateTime.now(),
        metadata = metadata ?? {};

  // Convertir el modelo en mapa para Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'category': category,
      'contentUrl': contentUrl,
      'textContent': textContent,
      'duration': duration,
      'tags': tags,
      'difficulty': difficulty,
      'isPublic': isPublic,
      'isFeatured': isFeatured,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'authorId': authorId,
      'metadata': metadata,
    };
  }

  // Metodo Factory para crear el modelo desde un mapa de Firestore
  factory ContentResource.fromMap(Map<String, dynamic> map) {
    return ContentResource(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      type: map['type'] ?? 'article',
      category: map['category'] ?? 'general',
      contentUrl: map['contentUrl'],
      textContent: map['textContent'],
      duration: map['duration'] ?? 0,
      tags: List<String>.from(map['tags'] ?? []),
      difficulty: map['difficulty'] ?? 'beginner',
      isPublic: map['isPublic'] ?? true,
      isFeatured: map['isFeatured'] ?? false,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] as Timestamp).toDate()
          : null,
      authorId: map['authorId'] ?? '',
      metadata: Map<String, dynamic>.from(map['metadata'] ?? {}),
    );
  }
}

// Modelo para progreso del usuario con contenido
class UserProgress {
  final String id;
  final String userId;
  final String resourceId;
  final bool isCompleted;
  final int progress; // Porcentaje 0-100
  final DateTime startedAt;
  final DateTime? completedAt;
  final DateTime lastAccessedAt;
  final int accessCount;
  final Map<String, dynamic> progressData; // Datos específicos del progreso

  // Constructor
  UserProgress({
    required this.id,
    required this.userId,
    required this.resourceId,
    this.isCompleted = false,
    this.progress = 0,
    DateTime? startedAt,
    this.completedAt,
    DateTime? lastAccessedAt,
    this.accessCount = 0,
    Map<String, dynamic>? progressData,
  })  : startedAt = startedAt ?? DateTime.now(),
        lastAccessedAt = lastAccessedAt ?? DateTime.now(),
        progressData = progressData ?? {};

  // Convertir el modelo en mapa para Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'resourceId': resourceId,
      'isCompleted': isCompleted,
      'progress': progress,
      'startedAt': Timestamp.fromDate(startedAt),
      'completedAt':
          completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'lastAccessedAt': Timestamp.fromDate(lastAccessedAt),
      'accessCount': accessCount,
      'progressData': progressData,
    };
  }

  // Metodo Factory para crear el modelo desde un mapa de Firestore
  factory UserProgress.fromMap(Map<String, dynamic> map) {
    return UserProgress(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      resourceId: map['resourceId'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      progress: map['progress'] ?? 0,
      startedAt: map['startedAt'] != null
          ? (map['startedAt'] as Timestamp).toDate()
          : DateTime.now(),
      completedAt: map['completedAt'] != null
          ? (map['completedAt'] as Timestamp).toDate()
          : null,
      lastAccessedAt: map['lastAccessedAt'] != null
          ? (map['lastAccessedAt'] as Timestamp).toDate()
          : DateTime.now(),
      accessCount: map['accessCount'] ?? 0,
      progressData: Map<String, dynamic>.from(map['progressData'] ?? {}),
    );
  }

  // Crear una copia con modificaciones
  UserProgress copyWith({
    bool? isCompleted,
    int? progress,
    DateTime? completedAt,
    DateTime? lastAccessedAt,
    int? accessCount,
    Map<String, dynamic>? progressData,
  }) {
    return UserProgress(
      id: this.id,
      userId: this.userId,
      resourceId: this.resourceId,
      isCompleted: isCompleted ?? this.isCompleted,
      progress: progress ?? this.progress,
      startedAt: this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
      accessCount: accessCount ?? this.accessCount,
      progressData: progressData ?? this.progressData,
    );
  }

  // Actualizar progreso
  UserProgress updateProgress(int newProgress) {
    final now = DateTime.now();
    return copyWith(
      progress: newProgress.clamp(0, 100),
      isCompleted: newProgress >= 100,
      completedAt: newProgress >= 100 ? now : null,
      lastAccessedAt: now,
      accessCount: accessCount + 1,
    );
  }
}
