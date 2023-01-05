import 'package:flutter/material.dart';
import 'package:free_quizme/widgets/double_face_card_widget.dart';

class StudyScreen extends StatelessWidget {
  const StudyScreen({super.key, required this.subjectName});

  final String subjectName;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(subjectName),
      ),
      body: SafeArea(
        child: Center(
          child: DoubleFaceCardWidget(),
        ),
      ),
    );
  }
}
