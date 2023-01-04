import 'package:flutter/material.dart';

class CollectionCard extends StatelessWidget {
  const CollectionCard({
    Key? key,
    required this.subjectName,
    required this.count,
  }) : super(key: key);

  final String subjectName;
  final String count;

  _showDialog(String action, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(action[0].toUpperCase() + action.substring(1)),
        content: Text(action[0].toUpperCase() +
            action.substring(1) +
            ' this collection?'),
        actions: [
          TextButton(
            onPressed: () {
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
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => print('Go to this collection'),
      child: SizedBox(
        height: 200,
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
                          _showDialog('delete', context);
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.redAccent,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _showDialog('edit', context);
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
