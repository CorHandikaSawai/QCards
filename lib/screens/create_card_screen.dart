import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qcards/screens/homepage_screen.dart';
import 'package:qcards/services/card_service.dart';
import 'package:qcards/widgets/card_form_widget.dart';

class CreateCardsScreen extends StatefulWidget {
  const CreateCardsScreen({super.key, required this.subjectName});

  final String? subjectName;

  @override
  State<CreateCardsScreen> createState() => _CreateCardsScreenState();
}

class _CreateCardsScreenState extends State<CreateCardsScreen> {
  ScrollController scrollController = ScrollController();
  List<CardFormWidget> listOfCards = [CardFormWidget()];

  @override
  Widget build(BuildContext context) {
    final cardService = Provider.of<CardService>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.subjectName.toString()),
        actions: [
          Tab(
            child: TextButton(
              onPressed: () async {
                await cardService
                    .saveAllCards(
                        userId: FirebaseAuth.instance.currentUser!.uid,
                        subjectName: widget.subjectName.toString(),
                        cards: listOfCards)
                    .then((_) => {
                          if (cardService.error.isNotEmpty)
                            {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(cardService.error),
                                  backgroundColor: Colors.red[700],
                                ),
                              ),
                            }
                          else if (mounted)
                            {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const HomePageScreen(),
                                  ),
                                  (route) => false)
                            }
                        });
              },
              child: cardService.isLoading
                  ? const CircularProgressIndicator.adaptive()
                  : const Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Form(
          autovalidateMode: AutovalidateMode.always,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              verticalDirection: VerticalDirection.up,
              children: listOfCards,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            listOfCards.add(CardFormWidget());
          });
          scrollController.animateTo(scrollController.position.minScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut);
        },
        child: const Icon(Icons.library_add_rounded),
      ),
    );
  }
}
