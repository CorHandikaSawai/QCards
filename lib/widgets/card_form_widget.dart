import 'package:flutter/material.dart';

class CardFormWidget extends StatefulWidget {
  CardFormWidget(
      {super.key, this.initialAnswer, this.initialQuestion, this.cardId});

  final TextEditingController questionFieldController = TextEditingController();
  final TextEditingController answerFieldController = TextEditingController();
  final String? initialQuestion;
  final String? initialAnswer;
  final String? cardId;

  @override
  State<CardFormWidget> createState() => _CardFormWidgetState();
}

class _CardFormWidgetState extends State<CardFormWidget> {
  var counter = 0;

  @override
  void initState() {
    if (widget.initialQuestion != null) {
      widget.questionFieldController.text = widget.initialQuestion!;
    }
    if (widget.initialAnswer != null) {
      widget.answerFieldController.text = widget.initialAnswer!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      color: Colors.black12,
      child: InkWell(
        onLongPress: () {
          setState(() {
            counter++;
          });
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Delete'),
              content: const Text('Delete this card?'),
              actions: [
                TextButton(
                  onPressed: () {
                    print('Yes');
                    Navigator.pop(context);
                  },
                  child: const Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    print('No');
                    Navigator.pop(context);
                  },
                  child: const Text('No'),
                ),
              ],
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(5),
                child: const Text('Question'),
              ),
              TextFormField(
                controller: widget.questionFieldController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                maxLength: 3000, //About 500 words or one single spaced page
              ),
              Container(
                margin: const EdgeInsets.all(5),
                child: const Text('Answer'),
              ),
              TextFormField(
                controller: widget.answerFieldController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                maxLength: 3000, //About 500 words or one single spaced page
              ),
            ],
          ),
        ),
      ),
    );
  }
}
