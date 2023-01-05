import 'package:flutter/material.dart';
import 'package:free_quizme/screens/homepage_screen.dart';
import 'package:free_quizme/services/auth_service.dart';
import 'package:free_quizme/services/card_service.dart';
import 'package:provider/provider.dart';

class CollectionCard extends StatelessWidget {
  const CollectionCard({
    Key? key,
    required this.subjectName,
    required this.count,
  }) : super(key: key);

  final String subjectName;
  final String count;

  _showDialog(String action, BuildContext context, userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(action[0].toUpperCase() + action.substring(1)),
        content: Text(action[0].toUpperCase() +
            action.substring(1) +
            ' this collection?'),
        actions: [
          TextButton(
            onPressed: () async {
              if (action == 'delete') {
                await CardService()
                    .deleteCollection(subjectName: subjectName, userId: userId)
                    .then(
                      (_) => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePageScreen(),
                          ),
                          (route) => false),
                    );
              }
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthenticationService>(context);
    return InkWell(
      onTap: () => print('Go to this collection'),
      child: SizedBox(
        height: 100,
        child: Card(
          color: Colors.black12,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(subjectName),
                      Text('$count cards'),
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
                              authService.currentUser!.userId);
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.redAccent,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _showDialog(
                              'edit', context, authService.currentUser!.userId);
                        },
                        icon: Icon(
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
