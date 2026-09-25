import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/auth_service.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool firebaseInitialized = false;
  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyC1MjOue8DWmDx7RByflY9G2PWrlGoRAUo",
          authDomain: "school-project-c69e6.firebaseapp.com",
          projectId: "school-project-c69e6",
          storageBucket: "school-project-c69e6.firebasestorage.app",
          messagingSenderId: "1054462077721",
          appId: "1:1054462077721:web:f87a744e846b32b899f388",
          measurementId: "G-WLECTQ26T9",
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
    firebaseInitialized = true;
  } catch (e) {
    debugPrint('Firebase initialization note: $e');
  }

  runApp(MealDBApp(isFirebaseReady: firebaseInitialized));
}

class MealDBApp extends StatelessWidget {
  final bool isFirebaseReady;

  const MealDBApp({super.key, this.isFirebaseReady = false});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MealDB App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 199, 36, 14),
        ),
        useMaterial3: true,
      ),
      home: !isFirebaseReady
          ? const HomeScreen()
          : StreamBuilder<User?>(
              stream: AuthService().authStateChanges,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasData) {
                  return const HomeScreen();
                }
                return const AuthScreen();
              },
            ),
    );
  }
}