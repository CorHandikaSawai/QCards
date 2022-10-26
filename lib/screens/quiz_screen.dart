import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:free_quizme/widgets/answer.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Title of the Subject"),
        centerTitle: true,
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: const EdgeInsets.all(5.0),
              height: screenSize.height * 0.4,
              color: Colors.black12,
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'Consectetur excepteur culpa sint quis aute anim id. Duis nulla excepteur '
                    'officia mollit proident Lorem laboris consequat ad tempor aute cupidatat qui'
                    'est. Irure eiusmod occaecat exercitation laborum eiusmod deserunt cillum adipisicing.',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ),
            Answer(
              letter: 'A',
            ),
            Answer(
              letter: 'B',
            ),
            Answer(
              letter: 'C',
            ),
            Answer(
              letter: 'D',
            ),
          ],
        ),
      ),
    );
  }
}
