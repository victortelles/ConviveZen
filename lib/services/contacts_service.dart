import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_contact.dart';

// Servicio para gestionar contactos de emergencia en Firestore
class ContactsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Referencia a la subcoleccion de contactos de un usuario
  CollectionReference _getContactsCollection(String userId) {
    return _firestore.collection('users').doc(userId).collection('contacts');
  }

  // CREATE | Crear un nuevo contacto de emergencia
  Future<String> createContact(UserContact contact) async {
    try {
      final docRef = await _getContactsCollection(contact.userId).add(contact.toMap());
      
      // Actualizar el ID del contacto con el ID generado por Firestore
      await docRef.update({'id': docRef.id});
      
      return docRef.id;
    } catch (e) {
      print('Error creating contact: $e');
      throw e;
    }
  }

  // READ | Obtener todos los contactos de emergencia de un usuario
  Future<List<UserContact>> getContacts(String userId) async {
    try {
      final snapshot = await _getContactsCollection(userId)
          .orderBy('priority')
          .get();

      return snapshot.docs
          .map((doc) => UserContact.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting contacts: $e');
      throw e;
    }
  }

  // READ | Stream de contactos en tiempo real
  Stream<List<UserContact>> getContactsStream(String userId) {
    return _getContactsCollection(userId)
        .orderBy('priority')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserContact.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }

  // READ | Obtener un contacto específico por ID
  Future<UserContact?> getContactById(String userId, String contactId) async {
    try {
      final doc = await _getContactsCollection(userId).doc(contactId).get();
      
      if (doc.exists && doc.data() != null) {
        return UserContact.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting contact by ID: $e');
      throw e;
    }
  }

  // UPDATE | Actualizar un contacto de emergencia
  Future<void> updateContact(UserContact contact) async {
    try {
      await _getContactsCollection(contact.userId)
          .doc(contact.id)
          .update(contact.toMap());
    } catch (e) {
      print('Error updating contact: $e');
      throw e;
    }
  }

  // DELETE | Eliminar un contacto de emergencia
  Future<void> deleteContact(String userId, String contactId) async {
    try {
      await _getContactsCollection(userId).doc(contactId).delete();
    } catch (e) {
      print('Error deleting contact: $e');
      throw e;
    }
  }

  // UTILITY | Marcar contacto como contactado
  Future<void> markAsContacted(String userId, String contactId) async {
    try {
      await _getContactsCollection(userId).doc(contactId).update({
        'lastContacted': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      print('Error marking contact as contacted: $e');
      throw e;
    }
  }

  // UTILITY | Obtener contacto principal (isPrimary = true)
  Future<UserContact?> getPrimaryContact(String userId) async {
    try {
      final snapshot = await _getContactsCollection(userId)
          .where('isPrimary', isEqualTo: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return UserContact.fromMap(snapshot.docs.first.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting primary contact: $e');
      throw e;
    }
  }

  // UTILITY | Verificar si el usuario tiene al menos un contacto
  Future<bool> hasContacts(String userId) async {
    try {
      final snapshot = await _getContactsCollection(userId).limit(1).get();
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking if user has contacts: $e');
      return false;
    }
  }

  // UTILITY | Actualizar prioridades de contactos
  Future<void> updateContactsPriority(String userId, List<String> contactIds) async {
    try {
      for (int i = 0; i < contactIds.length; i++) {
        await _getContactsCollection(userId).doc(contactIds[i]).update({
          'priority': i + 1,
        });
      }
    } catch (e) {
      print('Error updating contacts priority: $e');
      throw e;
    }
  }
}
