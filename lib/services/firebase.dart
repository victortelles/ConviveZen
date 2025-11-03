import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Referencia a la colección de usuarios
  CollectionReference get _usersCollection => _firestore.collection('users');

  // CREATE | Funcionalidad para crear un nuevo usuario en Firestore
  Future<void> createUser(UserModel user) async {
    try {
      await _usersCollection.doc(user.uid).set(user.toMap());
    } catch (e) {
      print('Error creating user: $e');
      throw e;
    }
  }

  // GET | Funcionalidad para Obtener usuario por ID
  Future<UserModel?> getUserById(String uid) async {
    try {
      DocumentSnapshot doc = await _usersCollection.doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      throw e;
    }
  }

  // GET | Funcionalidad para Obtener usuario actual
  Future<UserModel?> getCurrentUser() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        return await getUserById(currentUser.uid);
      }
      return null;
    } catch (e) {
      print('Error getting current user: $e');
      throw e;
    }
  }

  // UPDATE | Funcionalidad Actualizar usuario
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    try {
      await _usersCollection.doc(uid).update(data);
    } catch (e) {
      print('Error updating user: $e');
      throw e;
    }
  }

  // Guardar preferencias de usuario después del onboarding
  Future<void> saveUserPreferences({
    required String uid,
    String? gender,
  }) async {
    Map<String, dynamic> data = {};

    if (gender != null) data['gender'] = gender;

    await updateUser(uid, data);
  }

  // UPDATE | Funcionalidad para actualizar el perfil del usuario (incluyendo la imagen)
  Future<void> updateUserProfile(UserModel updatedUser) async {
    try {
      await _usersCollection.doc(updatedUser.uid).update({
        'profile_pic': updatedUser.profilePic,
      });
    } catch (e) {
      print('Error updating user profile: $e');
      throw e;
    }
  }

  // DELETE | Funcionalidad para eliminar completamente un usuario y todos sus datos
  Future<void> deleteUser(String uid) async {
    try {
      // Eliminar subcolección de preferences
      final preferencesCollection = _usersCollection.doc(uid).collection('preferences');
      final preferencesSnapshot = await preferencesCollection.get();

      for (DocumentSnapshot doc in preferencesSnapshot.docs) {
        await doc.reference.delete();
      }

      // Eliminar otras subcolecciones si existen (contacts, tools, logs, etc.)
      final collections = ['contacts', 'tools', 'crisis_logs', 'sessions'];
      for (String collectionName in collections) {
        final collection = _usersCollection.doc(uid).collection(collectionName);
        final snapshot = await collection.get();

        for (DocumentSnapshot doc in snapshot.docs) {
          await doc.reference.delete();
        }
      }

      // Eliminar el documento principal del usuario
      await _usersCollection.doc(uid).delete();

      print('Usuario y todos sus datos eliminados de Firestore: $uid');
    } catch (e) {
      print('Error eliminando datos del usuario: $e');
      throw e;
    }
  }

}
