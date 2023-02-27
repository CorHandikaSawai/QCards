import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:free_quizme/firebase_options.dart';
import 'package:free_quizme/screens/login_user_screen.dart';
import 'package:free_quizme/screens/test_screen.dart';
import 'package:free_quizme/services/auth_service.dart';
import 'package:free_quizme/services/card_service.dart';
import 'package:free_quizme/services/user_preference_service.dart';
import 'package:free_quizme/services/user_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserPreference(),
        ),
        ChangeNotifierProvider(
          create: (_) => CardService(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthenticationService(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserService(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final userPreference = Provider.of<UserPreference>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Free Quizme',
      theme: userPreference.theme,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data!.email);
            return TestScreen();
          }
          return LoginUserScreen();
        },
      ),
    );
  }
}
