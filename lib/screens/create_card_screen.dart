import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:free_quizme/screens/flashcards_screen.dart';
import 'package:free_quizme/services/qa_cards_service.dart';
import 'package:free_quizme/widgets/qa_cards.dart';

class CreateCardsScreen extends StatefulWidget {
  const CreateCardsScreen({super.key});

  @override
  State<CreateCardsScreen> createState() => _CreateCardsScreenState();
}

class _CreateCardsScreenState extends State<CreateCardsScreen> {
  ScrollController scrollController = ScrollController();
  List<CardForm> listOfCards = [CardForm()];
  CardService cardService = CardService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Tab(
            child: IconButton(
              onPressed: () {
                setState(() {
                  listOfCards.add(CardForm());
                });
                scrollController.animateTo(
                    scrollController.position.minScrollExtent,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              },
              icon: Icon(Icons.add),
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
      bottomNavigationBar: BottomAppBar(
        child: IconButton(
          onPressed: () async {
            await cardService.saveAllCards('test', listOfCards);
            setState(() {
              listOfCards.clear();
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FlashcardsScreen(),
              ),
            );
          },
          icon: Icon(Icons.save),
        ),
      ),
    );
  }
}
