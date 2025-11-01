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
  final bool isFirstTime; // Flag to check if user needs onboarding

  // Basic user data - required for initial registration
  final DateTime? birthdate; // Used to calculate age
  
  // Anxiety-specific data - filled during onboarding
  final List<String> anxietyTypes; // Multiple anxiety types can be selected
  final int? anxietyLevel; // 1-10 scale
  final String? personalityType; // 'introvert', 'extrovert', 'ambivert'
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
    this.isFirstTime = true, // Default to true for new users
    DateTime? createdAt,
    this.birthdate,
    List<String>? anxietyTypes,
    this.anxietyLevel,
    this.personalityType,
    List<String>? triggers,
    this.hasSubscription = false,
    this.subscriptionExpiry,
  })  : this.createdAt = createdAt ?? DateTime.now(),
        this.anxietyTypes = anxietyTypes ?? [],
        this.triggers = triggers ?? [];

  // Helper method to calculate age from birthdate
  int? get age {
    if (birthdate == null) return null;
    final now = DateTime.now();
    int age = now.year - birthdate!.year;
    if (now.month < birthdate!.month || 
        (now.month == birthdate!.month && now.day < birthdate!.day)) {
      age--;
    }
    return age;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      profilePic: map['profilePic'],
      authProvider: map['authProvider'] ?? 'email',
      isActive: map['isActive'] ?? true,
      isFirstTime: map['isFirstTime'] ?? true,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] is Timestamp
              ? (map['createdAt'] as Timestamp).toDate()
              : DateTime.parse(map['createdAt']))
          : DateTime.now(),
      birthdate: map['birthdate'] != null
          ? (map['birthdate'] is Timestamp
              ? (map['birthdate'] as Timestamp).toDate()
              : DateTime.parse(map['birthdate']))
          : null,
      anxietyTypes: List<String>.from(map['anxietyTypes'] ?? []),
      anxietyLevel: map['anxietyLevel'],
      personalityType: map['personalityType'],
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
      'isFirstTime': isFirstTime,
      'createdAt': createdAt.toIso8601String(),
      'birthdate': birthdate?.toIso8601String(),
      'anxietyTypes': anxietyTypes,
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
    bool? isFirstTime,
    DateTime? birthdate,
    List<String>? anxietyTypes,
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
      isFirstTime: isFirstTime ?? this.isFirstTime,
      createdAt: this.createdAt,
      birthdate: birthdate ?? this.birthdate,
      anxietyTypes: anxietyTypes ?? this.anxietyTypes,
      anxietyLevel: anxietyLevel ?? this.anxietyLevel,
      personalityType: personalityType ?? this.personalityType,
      triggers: triggers ?? this.triggers,
      hasSubscription: hasSubscription ?? this.hasSubscription,
      subscriptionExpiry: subscriptionExpiry ?? this.subscriptionExpiry,
    );
  }
}
