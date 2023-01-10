import 'package:flutter/material.dart';

class Flashcard extends StatefulWidget {
  const Flashcard({super.key, required this.height, required this.width});

  final double height, width;
  @override
  State<Flashcard> createState() => _FlashcardState();
}

class _FlashcardState extends State<Flashcard> {
  var crossFade = CrossFadeState.showFirst;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('here');
        setState(() {
          if (crossFade == CrossFadeState.showFirst) {
            crossFade = CrossFadeState.showSecond;
          } else {
            crossFade = CrossFadeState.showFirst;
          }
        });
      },
      child: AnimatedCrossFade(
        duration: const Duration(seconds: 1),
        firstChild: Container(
          color: Colors.blueAccent,
          height: widget.height,
          width: widget.width,
          child: Center(
            child: Text('data'),
          ),
        ),
        secondChild: Container(
          color: Colors.blueAccent,
          height: widget.height,
          width: widget.width,
          child: Center(
            child: Text('data2'),
          ),
        ),
        crossFadeState: crossFade,
      ),
    );
  }
}
