import 'package:flutter/material.dart';
import 'package:convivezen/firebase_options.dart';
import 'package:convivezen/screens/auth/login_options.dart';
import 'package:convivezen/screens/home/home.dart';
import 'package:convivezen/screens/auth/login.dart';
import 'package:convivezen/screens/onboarding/onboarding_flow.dart';
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
    return Consumer<AppState>(
      builder: (context, appState, child) {
        // Pantalla principal de la aplicación
        return MaterialApp(
          title: 'ConviveZen',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.pink,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            brightness: Brightness.light,
            scaffoldBackgroundColor: Colors.pink[50],
          ),
          // Tema oscuro
          darkTheme: ThemeData(
            primarySwatch: Colors.pink,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: Colors.grey[900],
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.grey[850],
              foregroundColor: Colors.white,
            ),
            cardTheme: CardTheme(
              color: Colors.grey[800],
            ),
          ),
          themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          //Inicializar ruta
          initialRoute: '/',
          //Rutas
          routes: {
            '/': (context) => LoginOptions(),
            '/login': (context) => LoginScreen(),
            '/home': (context) => HomeScreen(),
            '/onboarding': (context) => OnboardingFlow(),
          },
        );
      },
    );
  }
}
