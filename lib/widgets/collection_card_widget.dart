import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qcards/screens/edit_card_screen.dart';
import 'package:qcards/screens/homepage_screen.dart';
import 'package:qcards/screens/study_screen.dart';
import 'package:qcards/services/auth_service.dart';
import 'package:qcards/services/card_service.dart';
import 'package:provider/provider.dart';

class CollectionCard extends StatefulWidget {
  const CollectionCard({
    Key? key,
    required this.subjectName,
    required this.count,
  }) : super(key: key);

  final String subjectName;
  final String count;

  @override
  State<CollectionCard> createState() => _CollectionCardState();
}

class _CollectionCardState extends State<CollectionCard> {
  bool isLoading = false;

  _showDialog(String action, BuildContext context, userId) {
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
                await CardService()
                    .deleteCollection(
                        subjectName: widget.subjectName, userId: userId)
                    .then(
                      (_) => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePageScreen(),
                          ),
                          (route) => false),
                    );
                Navigator.of(context).pop();
              }
              if (action == 'edit') {
                await CardService()
                    .getCardsFromSubject(
                        subjectName: widget.subjectName, userId: userId)
                    .then(
                      (cards) => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditCardsScreen(
                              subjectName: widget.subjectName,
                              cards: cards,
                            ),
                          ),
                          (route) => false),
                    );
                setState(() {
                  isLoading = false;
                });
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
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudyScreen(
              subjectName: widget.subjectName,
              userId: FirebaseAuth.instance.currentUser!.uid,
            ),
          ),
        );
      },
      child: SizedBox(
        height: 150,
        child: Card(
          color: Colors.white,
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        widget.subjectName,
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        '${widget.count} ${int.parse(widget.count) > 1 ? 'cards' : 'card'}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          _showDialog('delete', context,
                              FirebaseAuth.instance.currentUser!.uid);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.redAccent,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _showDialog('edit', context,
                              FirebaseAuth.instance.currentUser!.uid);
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
