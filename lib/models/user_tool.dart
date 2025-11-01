import 'package:cloud_firestore/cloud_firestore.dart';

// Custom tool configuration model for personalized emergency tools
class UserTool {
  final String id;
  final String userId;
  final String type; // 'music', 'game', 'breathing', 'meditation', 'affirmation', 'chat'
  final String name; // Custom name for the tool
  final String? description;
  final Map<String, dynamic> configuration; // Tool-specific settings
  final bool isActive;
  final bool isDefault; // If it's a system default tool
  final int priority; // Order in emergency menu
  final DateTime createdAt;
  final DateTime? lastUsed;
  final int usageCount;

  UserTool({
    required this.id,
    required this.userId,
    required this.type,
    required this.name,
    this.description,
    Map<String, dynamic>? configuration,
    this.isActive = true,
    this.isDefault = false,
    this.priority = 1,
    DateTime? createdAt,
    this.lastUsed,
    this.usageCount = 0,
  })  : this.configuration = configuration ?? {},
        this.createdAt = createdAt ?? DateTime.now();

  factory UserTool.fromMap(Map<String, dynamic> map) {
    return UserTool(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      type: map['type'] ?? 'breathing',
      name: map['name'] ?? '',
      description: map['description'],
      configuration: Map<String, dynamic>.from(map['configuration'] ?? {}),
      isActive: map['isActive'] ?? true,
      isDefault: map['isDefault'] ?? false,
      priority: map['priority'] ?? 1,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] is Timestamp
              ? (map['createdAt'] as Timestamp).toDate()
              : DateTime.parse(map['createdAt']))
          : DateTime.now(),
      lastUsed: map['lastUsed'] != null
          ? (map['lastUsed'] is Timestamp
              ? (map['lastUsed'] as Timestamp).toDate()
              : DateTime.parse(map['lastUsed']))
          : null,
      usageCount: map['usageCount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'name': name,
      'description': description,
      'configuration': configuration,
      'isActive': isActive,
      'isDefault': isDefault,
      'priority': priority,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastUsed': lastUsed != null ? Timestamp.fromDate(lastUsed!) : null,
      'usageCount': usageCount,
    };
  }

  UserTool copyWith({
    String? name,
    String? description,
    Map<String, dynamic>? configuration,
    bool? isActive,
    int? priority,
    DateTime? lastUsed,
    int? usageCount,
  }) {
    return UserTool(
      id: this.id,
      userId: this.userId,
      type: this.type,
      name: name ?? this.name,
      description: description ?? this.description,
      configuration: configuration ?? this.configuration,
      isActive: isActive ?? this.isActive,
      isDefault: this.isDefault,
      priority: priority ?? this.priority,
      createdAt: this.createdAt,
      lastUsed: lastUsed ?? this.lastUsed,
      usageCount: usageCount ?? this.usageCount,
    );
  }

  // Mark tool as used
  UserTool markUsed() {
    return copyWith(
      lastUsed: DateTime.now(),
      usageCount: usageCount + 1,
    );
  }

  // Get tool icon based on type
  String get iconName {
    switch (type) {
      case 'music':
        return 'music_note';
      case 'game':
        return 'videogame_asset';
      case 'breathing':
        return 'air';
      case 'meditation':
        return 'self_improvement';
      case 'affirmation':
        return 'favorite';
      case 'chat':
        return 'chat';
      default:
        return 'help';
    }
  }

  // Create default tools for new users
  static List<UserTool> createDefaultTools(String userId) {
    return [
      UserTool(
        id: 'breathing_$userId',
        userId: userId,
        type: 'breathing',
        name: 'Respiracion Profunda',
        description: 'Ejercicios de respiracion para calmar la ansiedad',
        isDefault: true,
        priority: 1,
        configuration: {'duration': 5, 'pattern': '4-7-8'},
      ),
      UserTool(
        id: 'music_$userId',
        userId: userId,
        type: 'music',
        name: 'Musica Relajante',
        description: 'Playlist personalizada para relajarse',
        isDefault: true,
        priority: 2,
        configuration: {'genre': 'ambient', 'volume': 0.7},
      ),
      UserTool(
        id: 'affirmation_$userId',
        userId: userId,
        type: 'affirmation',
        name: 'Afirmaciones',
        description: 'Palabras de motivacion y calma',
        isDefault: true,
        priority: 3,
        configuration: {'tone': 'calming', 'duration': 3},
      ),
    ];
  }
}
