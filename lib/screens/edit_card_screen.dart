// Required imports
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:qcards/screens/homepage_screen.dart';
import 'package:qcards/services/card_service.dart';
import 'package:qcards/widgets/card_form_widget.dart';

/// Screen for editing an existing set of cards under a subject/collection.
class EditCardsScreen extends StatefulWidget {
  const EditCardsScreen({
    super.key,
    required this.cards,
    required this.subjectName,
  });

  /// List of cards to edit, each containing question, answer, and cardId.
  final List<Map<String, String>> cards;

  /// Name of the subject/collection being edited.
  final String subjectName;

  @override
  State<EditCardsScreen> createState() => _EditCardsScreenState();
}

class _EditCardsScreenState extends State<EditCardsScreen> {
  // Scroll controller for scrolling to new cards when added
  ScrollController scrollController = ScrollController();

  // List of card form widgets that are shown on the screen
  List<CardFormWidget> listOfCards = [];

  @override
  void initState() {
    super.initState();
    listOfCards.clear();

    // Initialize form widgets with preloaded card data
    for (var card in widget.cards) {
      listOfCards.add(CardFormWidget(
        initialQuestion: card['question'],
        initialAnswer: card['answer'],
        cardId: card['cardId'],
        isUpdated: false,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardService = Provider.of<CardService>(context);

    return Scaffold(
      // 🧠 App bar with back and save buttons
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePageScreen()),
              (route) => false,
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text('Editing ${widget.subjectName}'),
        centerTitle: true,
        actions: [
          // Save button to update all edited cards
          Tab(
            child: TextButton(
              onPressed: () async {
                await cardService.updateCards(
                  userId: FirebaseAuth.instance.currentUser!.uid,
                  subjectName: widget.subjectName,
                  cards: listOfCards,
                );
                if (mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomePageScreen()),
                    (route) => false,
                  );
                }
              },
              child: cardService.isLoading
                  ? const CircularProgressIndicator.adaptive(
                      backgroundColor: Colors.white,
                    )
                  : const Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
            ),
          ),
        ],
      ),

      // 🧠 Body: Editable list of cards
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

      // ➕ Button to add a new blank card
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            listOfCards.add(CardFormWidget());
          });

          // Scroll to the bottom to show the new card
          scrollController.animateTo(
            scrollController.position.minScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        child: const Icon(Icons.library_add_rounded),
      ),
    );
  }
}
