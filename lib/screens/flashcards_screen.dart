import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:free_quizme/widgets/flashcards.dart';

class FlashcardsScreen extends StatefulWidget {
  const FlashcardsScreen({super.key});

  @override
  State<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends State<FlashcardsScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Card Collection Name'),
        ),
        body: Stack(
          children: [
            Center(
              child: Flashcard(
                height: screenSize.height * 0.6,
                width: screenSize.width * 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
