import 'package:cloud_firestore/cloud_firestore.dart';

//Modelo de usuarios para bases de datos
class UserModel {
  final String uid;
  final String email;
  final String name;
  final String? gender;
  final DateTime? birthdate;
  final GeoPoint? location;
  final List<String> favorites;
  final List<String> habits;
  final List<String> sports;
  final List<String> exerciseTypes;
  final List<String> trainingDays;
  final String? profilePic;
  final DateTime createdAt;
  final String role;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    this.gender,
    this.birthdate,
    this.location,
    this.favorites = const [],
    this.habits = const [],
    this.sports = const [],
    this.exerciseTypes = const [],
    this.trainingDays = const [],
    this.profilePic,
    this.role = 'user',
    DateTime? createdAt,
  }) : this.createdAt = createdAt ?? DateTime.now();

  // Convertir de Map a UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      gender: map['gender'],
      birthdate: (map['birthdate'] as Timestamp?)?.toDate(),
      location: map['location'] as GeoPoint?,
      favorites: List<String>.from(map['favorites'] ?? []),
      habits: List<String>.from(map['habits'] ?? []),
      sports: List<String>.from(map['sports'] ?? []),
      exerciseTypes: List<String>.from(map['excersice_types'] ?? []),
      trainingDays: List<String>.from(map['training_days'] ?? []),
      profilePic: map['profile_pic'],
      role: map['role'] ?? 'user',
      createdAt: (map['created_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Convertir UserModel a Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'gender': gender,
      'birthdate': birthdate != null ? Timestamp.fromDate(birthdate!) : null,
      'location': location,
      'favorites': favorites,
      'habits': habits,
      'sports': sports,
      'excersice_types': exerciseTypes,
      'training_days': trainingDays,
      'profile_pic': profilePic,
      'role': role,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  // Crear un nuevo usuario con datos actualizados
  UserModel copyWith({
    String? gender,
    List<String>? habits,
    List<String>? sports,
    List<String>? exerciseTypes,
    List<String>? trainingDays,
    String? profilePic,
  }) {
    return UserModel(
      uid: this.uid,
      email: this.email,
      name: this.name,
      gender: gender ?? this.gender,
      birthdate: this.birthdate,
      location: this.location,
      favorites: this.favorites,
      habits: habits ?? this.habits,
      sports: sports ?? this.sports,
      exerciseTypes: exerciseTypes ?? this.exerciseTypes,
      trainingDays: trainingDays ?? this.trainingDays,
      profilePic: profilePic ?? this.profilePic,
      role: this.role,
      createdAt: this.createdAt,
    );
  }
}
