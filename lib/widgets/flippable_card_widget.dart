import 'package:firebase_auth/firebase_auth.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:qcards/services/card_service.dart';
import 'package:qcards/widgets/card_form_widget.dart';

class FlippableCardWidget extends StatefulWidget {
  const FlippableCardWidget({
    Key? key,
    required this.subjectName,
    required this.question,
    required this.answer,
    required this.flipCardKey,
    required this.cardId,
  }) : super(key: key);

  final String question;
  final String answer;
  final String cardId;
  final String subjectName;
  final GlobalKey<FlipCardState> flipCardKey;

  @override
  State<FlippableCardWidget> createState() => _FlippableCardWidgetState();
}

class _FlippableCardWidgetState extends State<FlippableCardWidget> {
  _showDialog(String action, BuildContext context, CardFormWidget thisCard) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          action[0].toUpperCase() + action.substring(1),
        ),
        content: Text(
            '${action[0].toUpperCase()}${action.substring(1)} this collection?'),
        actions: [
          TextButton(
            onPressed: () async {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Row(
                      children: [
                        const CircularProgressIndicator(),
                        Container(
                          margin: const EdgeInsets.only(left: 7),
                          child: const Text("Loading..."),
                        ),
                      ],
                    ),
                  );
                },
              );
              if (action == 'delete') {
                await CardService().deleteCard(
                    subjectName: widget.subjectName,
                    userId: FirebaseAuth.instance.currentUser!.uid,
                    card: thisCard);
                if (mounted) {
                  setState(() {
                    // TODO: Cannot set state inside builder. Find a way to update the widget
                  });
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.blueAccent,
                      content: Text("Please reload cards to see changes"),
                    ),
                  );
                }
              }
              if (action == 'save') {
                await CardService().saveCard(
                    subjectName: widget.subjectName,
                    userId: FirebaseAuth.instance.currentUser!.uid,
                    card: thisCard);
                if (mounted) {
                  setState(() {
                    // TODO: Cannot set state inside builder. Find a way to update the widget
                  });
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.blueAccent,
                      content: Text("Please reload cards to see changes"),
                    ),
                  );
                }
              }
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var thisCard = CardFormWidget(
      initialQuestion: widget.question,
      initialAnswer: widget.answer,
      cardId: widget.cardId,
      isUpdated: false,
    );
    return Stack(
      children: [
        FlipCard(
          key: widget.flipCardKey,
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
                      widget.question,
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
                    widget.answer,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Editing'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        thisCard,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                onPressed: () {
                                  _showDialog('delete', context, thisCard);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                onPressed: () {
                                  _showDialog('save', context, thisCard);
                                },
                                icon: const Icon(
                                  Icons.save,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              icon: Icon(Icons.edit),
            ),
          ),
        ),
      ],
    );
  }
}
