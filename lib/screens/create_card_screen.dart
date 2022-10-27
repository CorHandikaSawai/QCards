import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CreateCardsScreen extends StatefulWidget {
  const CreateCardsScreen({super.key});

  @override
  State<CreateCardsScreen> createState() => _CreateCardsScreenState();
}

class _CreateCardsScreenState extends State<CreateCardsScreen> {
  ScrollController scrollController = ScrollController();
  List<QACardForm> listOfCards = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Tab(
            child: IconButton(
              onPressed: () {
                setState(() {
                  listOfCards.add(QACardForm());
                });
                scrollController.animateTo(scrollController.position.minScrollExtent,
                    duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
              },
              icon: Icon(Icons.add),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Form(
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              verticalDirection: VerticalDirection.up,
              children: listOfCards,
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: IconButton(
          onPressed: () => print('save cards'),
          icon: Icon(Icons.save),
        ),
      ),
    );
  }
}

class QACardForm extends StatefulWidget {
  const QACardForm({
    Key? key,
  }) : super(key: key);
  @override
  State<QACardForm> createState() => _QACardFormState();
}

class _QACardFormState extends State<QACardForm> {
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
