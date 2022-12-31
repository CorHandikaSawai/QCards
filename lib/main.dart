import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:free_quizme/firebase_options.dart';
import 'package:free_quizme/screens/create_card_screen.dart';
import 'package:free_quizme/screens/homepage_screen.dart';
import 'package:free_quizme/screens/quiz_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Free Quizme',
      theme: ThemeData.dark(),
      home: const MyHomePage(),
    );
  }
}
