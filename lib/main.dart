import 'package:flutter/material.dart';
import 'package:convivezen/firebase_options.dart';
import 'package:convivezen/models/user_preferences.dart';
import 'package:convivezen/screens/gender_selection.dart';
import 'package:convivezen/screens/login_options.dart';
import 'package:convivezen/screens/home.dart';
import 'package:convivezen/screens/login.dart';
import 'package:convivezen/screens/events.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import './providers/app_state.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   if (Firebase.apps.isEmpty) {
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//   }
//   runApp(
//     ChangeNotifierProvider(
//       create: (context) => AppState(),
//       child: const MyApp(),
//     ),
//   );
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    if (e is FirebaseException && e.code == 'duplicate-app') {
    } else {
      rethrow;
    }
  }
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ConviveZen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //Inicializar ruta
      initialRoute: '/',
      //Rutas
      routes: {
        '/': (context) => LoginOptions(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        //Añadir gender_selection
        '/gender_selection': (context) =>
            GenderSelection(userPreferences: UserPreferences()),
        '/explore': (context) => ExploreScreen(),
      },
    );
  }
}
