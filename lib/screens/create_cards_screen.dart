import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CreateCards extends StatefulWidget {
  const CreateCards({super.key});

  @override
  State<CreateCards> createState() => _CreateCardsState();
}

class _CreateCardsState extends State<CreateCards> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: screenSize.height,
        child: Column(
          children: [
            Container(
              color: Colors.black,
              margin: EdgeInsets.all(5.0),
              child: TextField(keyboardType: TextInputType.multiline, maxLines: null,),
            ),
             Container(
              color: Colors.black,
              margin: EdgeInsets.all(5.0),
              child: TextField(keyboardType: TextInputType.multiline, maxLines: null,),
            ),
          ],
        ),
      ),
    );
  }
}
