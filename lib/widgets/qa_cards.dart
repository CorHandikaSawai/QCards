
import 'package:flutter/material.dart';

class CardForm extends StatefulWidget {
  CardForm({
    Key? key,
  }) : super(key: key);

  final TextEditingController questionFieldController = TextEditingController();
  final TextEditingController answerFieldController = TextEditingController();

  @override
  State<CardForm> createState() => _CardFormState();
}

class _CardFormState extends State<CardForm> {
  var counter = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      color: Colors.black12,
      child: InkWell(
        onLongPress: () {
          setState(() {
            counter++;
          });
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text('Delete'),
              content: Text('Delete this card?'),
              actions: [
                TextButton(
                  onPressed: () {
                    print('Yes');
                    Navigator.pop(context);
                  },
                  child: Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    print('No');
                    Navigator.pop(context);
                  },
                  child: Text('No'),
                ),
              ],
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(25.0),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(5),
                child: Text('Question $counter'),
              ),
              Container(
                child: TextFormField(
                  controller: widget.questionFieldController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
              ),
              Container(
                margin: EdgeInsets.all(5),
                child: Text('Answer'),
              ),
              Container(
                child: TextFormField(
                  controller: widget.answerFieldController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
