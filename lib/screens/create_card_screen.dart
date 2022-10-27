import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
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
          onPressed: (){
            cardService.saveAllCards('test', listOfCards);
            //TODO: empty the list, show success messages and redirect user to homepage or their new card collection.
          },
          icon: Icon(Icons.save),
        ),
      ),
    );
  }
}
