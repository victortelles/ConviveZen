import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:convivezen/models/user.dart';
import 'package:convivezen/services/firebase.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirestoreService _firestoreService = FirestoreService();

  // Verifica si el usuario ya está autenticado y navega en consecuencia
  Future<void> checkCurrentUser(BuildContext context) async {
    User? user = _auth.currentUser;
    print('DEBUG: Checking current user: ${user?.uid}');
    
    if (user != null) {
      try {
        final userModel = await _firestoreService.getUserById(user.uid);
        print('DEBUG: User model found: ${userModel?.email}, isFirstTime: ${userModel?.isFirstTime}');
        
        if (userModel != null) {
          // Update AppState with user profile
          final appState = Provider.of<AppState>(context, listen: false);
          await appState.saveUserToFirestore(userModel);
          
          // Check if user needs onboarding (isFirstTime = true)
          if (userModel.isFirstTime) {
            print('DEBUG: Redirecting to onboarding');
            Navigator.of(context).pushReplacementNamed('/onboarding');
          } else {
            print('DEBUG: Redirecting to home');
            Navigator.of(context).pushReplacementNamed('/home');
          }
        } else {
          print('DEBUG: User model is null, staying on login screen');
        }
      } catch (e) {
        print('DEBUG: Error checking user: $e');
      }
    } else {
      print('DEBUG: No current user, staying on login screen');
    }
  }

  // Autenticación con Google
  Future<void> signInWithGoogle(
      BuildContext context, Function(bool) onLoading) async {
    onLoading(true);
    try {
      // Forzar a seleccionar cuenta
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        onLoading(false);
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        final existingUser = await _firestoreService.getUserById(user.uid);

        if (existingUser == null) {
          // Create basic user profile - full data will be filled in onboarding
          final newUser = UserModel(
            uid: user.uid,
            email: user.email ?? '',
            name: user.displayName ?? 'Usuario',
            profilePic: user.photoURL,
            authProvider: 'google',
            isFirstTime: true, // User needs to complete onboarding
          );

          await Provider.of<AppState>(context, listen: false)
              .saveUserToFirestore(newUser);
          Navigator.of(context).pushReplacementNamed('/onboarding');
        } else {
          // Check if existing user needs onboarding
          if (existingUser.isFirstTime) {
            Navigator.of(context).pushReplacementNamed('/onboarding');
          } else {
            Navigator.of(context).pushReplacementNamed('/home');
          }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text("Error al iniciar sesión con Google: ${e.toString()}")),
      );
    } finally {
      onLoading(false);
    }
  }

  //Register with email - simplified for new flow
  Future<String?> registerWithEmail({
    required String name,
    required String email,
    required String password,
    required DateTime birthdate,
    required BuildContext context,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.updateDisplayName(name);

      // Create basic user profile - full data will be filled in onboarding
      final newUser = UserModel(
        uid: userCredential.user!.uid,
        email: email,
        name: name,
        authProvider: 'email',
        birthdate: birthdate,
        isFirstTime: true, // User needs to complete onboarding
      );

      // Save to Firestore
      await Provider.of<AppState>(context, listen: false)
          .saveUserToFirestore(newUser);

      return null; // Success - no error
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'El correo ya está en uso';
        case 'invalid-email':
          return 'Correo no válido';
        case 'weak-password':
          return 'La contraseña es muy débil';
        default:
          return 'Error: ${e.message}';
      }
    } catch (e) {
      return 'Error inesperado: $e';
    }
  }

  //Funcionalidad para resetear la password.
  Future<void> resetPassword({
    required String email,
    required BuildContext context,
  }) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Se ha enviado un correo para restablecer tu contraseña.')),
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No se encontró un usuario con ese correo.')),
          );
          break;
        case 'invalid-email':
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('El correo proporcionado no es válido.')),
          );
          break;
        default:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.message}')),
          );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error inesperado: $e')),
      );
    }
  }
}
