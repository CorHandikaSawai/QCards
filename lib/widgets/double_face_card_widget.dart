import 'package:flutter/material.dart';

class DoubleFaceCardWidget extends StatelessWidget {
  const DoubleFaceCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      color: Colors.black12,
      height: screenSize.height * 0.6,
      width: screenSize.width * 0.8,
      child: Center(
        child: Question(),
      ),
    );
  }
}

class Question extends StatelessWidget {
  const Question({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Question'),
    );
  }
}

class Answer extends StatelessWidget {
  const Answer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Answer'),
    );
  }
}
