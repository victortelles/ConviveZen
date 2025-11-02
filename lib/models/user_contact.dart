import 'package:cloud_firestore/cloud_firestore.dart';

// Emergency contact model for trusted people to notify during crisis
class UserContact {
  // Definicion de atributos
  final String id;
  final String userId;
  final String name;
  final String relationship;  // 'family', 'friend', 'partner', 'therapist', 'doctor', 'psychologist'
  final String contactInfo;   // Phone number or email
  final String contactType;   // 'phone', 'email', 'whatsapp'
  final bool notifyInEmergency;
  final bool isPrimary;       // Main emergency contact
  final int priority;         // Order of contact (1 = first, 2 = second, etc.)
  final DateTime createdAt;
  final DateTime? lastContacted;

  // Constructor
  UserContact({
    required this.id,
    required this.userId,
    required this.name,
    required this.relationship,
    required this.contactInfo,
    this.contactType = 'phone',
    this.notifyInEmergency = true,
    this.isPrimary = false,
    this.priority = 1,
    DateTime? createdAt,
    this.lastContacted,
  }) : this.createdAt = createdAt ?? DateTime.now();

  // Metodo Factory para crear el modelo desde un mapa de Firestore
  factory UserContact.fromMap(Map<String, dynamic> map) {
    return UserContact(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      relationship: map['relationship'] ?? 'friend',
      contactInfo: map['contactInfo'] ?? '',
      contactType: map['contactType'] ?? 'phone',
      notifyInEmergency: map['notifyInEmergency'] ?? true,
      isPrimary: map['isPrimary'] ?? false,
      priority: map['priority'] ?? 1,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] is Timestamp
              ? (map['createdAt'] as Timestamp).toDate()
              : DateTime.parse(map['createdAt']))
          : DateTime.now(),
      lastContacted: map['lastContacted'] != null
          ? (map['lastContacted'] is Timestamp
              ? (map['lastContacted'] as Timestamp).toDate()
              : DateTime.parse(map['lastContacted']))
          : null,
    );
  }

  // Convertir el modelo en mapa para Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'relationship': relationship,
      'contactInfo': contactInfo,
      'contactType': contactType,
      'notifyInEmergency': notifyInEmergency,
      'isPrimary': isPrimary,
      'priority': priority,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastContacted': lastContacted != null ? Timestamp.fromDate(lastContacted!) : null,
    };
  }

  // Método para clonar y actualizar campos específicos
  UserContact copyWith({
    String? name,
    String? relationship,
    String? contactInfo,
    String? contactType,
    bool? notifyInEmergency,
    bool? isPrimary,
    int? priority,
    DateTime? lastContacted,
  }) {
    return UserContact(
      id: this.id,
      userId: this.userId,
      name: name ?? this.name,
      relationship: relationship ?? this.relationship,
      contactInfo: contactInfo ?? this.contactInfo,
      contactType: contactType ?? this.contactType,
      notifyInEmergency: notifyInEmergency ?? this.notifyInEmergency,
      isPrimary: isPrimary ?? this.isPrimary,
      priority: priority ?? this.priority,
      createdAt: this.createdAt,
      lastContacted: lastContacted ?? this.lastContacted,
    );
  }

  // Mark contact as contacted
  UserContact markContacted() {
    return copyWith(lastContacted: DateTime.now());
  }

  // Check if contact is valid
  bool get isValid {
    return name.isNotEmpty && contactInfo.isNotEmpty;
  }

  // Get formatted contact display
  String get displayInfo {
    return '$name ($relationship)';
  }
}