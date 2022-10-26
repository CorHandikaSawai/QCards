import 'package:flutter/material.dart';

class Answer extends StatefulWidget {
  const Answer({
    Key? key,
    required this.letter,
  }) : super(key: key);

  final String letter;

  @override
  State<Answer> createState() => _AnswerState();
}

class _AnswerState extends State<Answer> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () => print('${widget.letter} clicked'),
        child: Container(
          margin: EdgeInsets.all(5),
          color: Colors.black12,
          child: Center(
            child: Text(
              widget.letter,
            ),
          ),
        ),
      ),
    );
  }
}
