/// Entry point of the QCards app.
/// Initializes Firebase and sets up global providers (services).
/// Uses StreamBuilder to decide between Login or Home screen based on auth state.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Responsive layout
import 'package:provider/provider.dart';

// Internal services and screens
import 'package:qcards/firebase_options.dart';
import 'package:qcards/screens/homepage_screen.dart';
import 'package:qcards/screens/login_user_screen.dart';
import 'package:qcards/services/auth_service.dart';
import 'package:qcards/services/card_service.dart';
import 'package:qcards/services/user_preference_service.dart';
import 'package:qcards/services/user_service.dart';

void main() async {
  // Ensures Flutter is fully initialized before Firebase is set up
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with auto-generated platform-specific options
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Set up global state providers using Provider package
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => UserPreference()), // Local user settings
        ChangeNotifierProvider(
            create: (_) => CardService()), // Card/collection logic
        ChangeNotifierProvider(
            create: (_) => AuthenticationService()), // Firebase Auth wrapper
        ChangeNotifierProvider(
            create: (_) => UserService()), // Firestore user management
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // Initializes screenutil for responsive sizing
      designSize: const Size(390, 844), // Reference device size (iPhone X/12)
      minTextAdapt: true,
      useInheritedMediaQuery: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Consumer<UserPreference>(builder: (context, userPref, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'QCards',
            // theme: userPref.theme,
            // Show different screen depending on Firebase auth state
            home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator
                      .adaptive(); // Still checking auth
                } else if (snapshot.data != null) {
                  return const HomePageScreen(); // User is logged in
                } else if (snapshot.hasError) {
                  print(snapshot.error.toString()); // Log error
                }
                return const LoginUserScreen(); // Default to login
              },
            ),
          );
        });
      },
    );
  }
}
