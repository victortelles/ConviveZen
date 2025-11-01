import 'package:cloud_firestore/cloud_firestore.dart';

// Main user profile model with anxiety-specific data
class UserModel {
  final String uid;
  final String email;
  final String name;
  final String? profilePic;
  final DateTime createdAt;
  final String authProvider; // 'email', 'google', etc.
  final bool isActive;

  // Anxiety-specific data
  final int age;
  final String anxietyType; // 'social', 'generalized', 'panic', 'specific_phobia', 'mixed'
  final int anxietyLevel; // 1-10 scale
  final String personalityType; // 'introvert', 'extrovert', 'ambivert'
  final List<String> triggers; // Main anxiety triggers
  final bool hasSubscription;
  final DateTime? subscriptionExpiry;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    this.profilePic,
    required this.authProvider,
    this.isActive = true,
    DateTime? createdAt,
    required this.age,
    required this.anxietyType,
    this.anxietyLevel = 5,
    required this.personalityType,
    List<String>? triggers,
    this.hasSubscription = false,
    this.subscriptionExpiry,
  })  : this.createdAt = createdAt ?? DateTime.now(),
        this.triggers = triggers ?? [];

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      profilePic: map['profilePic'],
      authProvider: map['authProvider'] ?? 'email',
      isActive: map['isActive'] ?? true,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] is Timestamp
              ? (map['createdAt'] as Timestamp).toDate()
              : DateTime.parse(map['createdAt']))
          : DateTime.now(),
      age: map['age'] ?? 18,
      anxietyType: map['anxietyType'] ?? 'generalized',
      anxietyLevel: map['anxietyLevel'] ?? 5,
      personalityType: map['personalityType'] ?? 'ambivert',
      triggers: List<String>.from(map['triggers'] ?? []),
      hasSubscription: map['hasSubscription'] ?? false,
      subscriptionExpiry: map['subscriptionExpiry'] != null
          ? (map['subscriptionExpiry'] is Timestamp
              ? (map['subscriptionExpiry'] as Timestamp).toDate()
              : DateTime.parse(map['subscriptionExpiry']))
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'profilePic': profilePic,
      'authProvider': authProvider,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'age': age,
      'anxietyType': anxietyType,
      'anxietyLevel': anxietyLevel,
      'personalityType': personalityType,
      'triggers': triggers,
      'hasSubscription': hasSubscription,
      'subscriptionExpiry': subscriptionExpiry?.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? name,
    String? profilePic,
    bool? isActive,
    int? age,
    String? anxietyType,
    int? anxietyLevel,
    String? personalityType,
    List<String>? triggers,
    bool? hasSubscription,
    DateTime? subscriptionExpiry,
  }) {
    return UserModel(
      uid: this.uid,
      email: this.email,
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      authProvider: this.authProvider,
      isActive: isActive ?? this.isActive,
      createdAt: this.createdAt,
      age: age ?? this.age,
      anxietyType: anxietyType ?? this.anxietyType,
      anxietyLevel: anxietyLevel ?? this.anxietyLevel,
      personalityType: personalityType ?? this.personalityType,
      triggers: triggers ?? this.triggers,
      hasSubscription: hasSubscription ?? this.hasSubscription,
      subscriptionExpiry: subscriptionExpiry ?? this.subscriptionExpiry,
    );
  }
}
