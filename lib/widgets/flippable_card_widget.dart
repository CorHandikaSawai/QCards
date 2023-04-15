import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

class FlippableCardWidget extends StatelessWidget {
  const FlippableCardWidget({
    Key? key,
    required this.question,
    required this.answer,
  }) : super(key: key);

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      fill: Fill.fillBack,
      front: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Card(
          elevation: 5,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Text(
                  question,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      ),
      back: Card(
        elevation: 5,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Text(
                answer,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
