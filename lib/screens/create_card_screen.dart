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
  var numOfCards = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Tab(
            child: TextButton(
              onPressed: () {
                print('Save cards');
              },
              child: Text('Save'),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Form(
          child: ListView.builder(
            controller: scrollController,
            itemCount: numOfCards,
            itemBuilder: (context, index) {
              return const QACardForm();
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: IconButton(
          onPressed: () {
            setState(() {
              numOfCards++;
            });
            scrollController.jumpTo(scrollController.position.maxScrollExtent);
          },
          icon: const Icon(Icons.add),
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
                    // setState(() {
                    //   scrollController;
                    // });
                    // print(scrollController);
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
                child: Text('Question $counter'),
              ),
              Container(
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
              ),
              Container(
                margin: const EdgeInsets.all(5),
                child: const Text('Answer'),
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
