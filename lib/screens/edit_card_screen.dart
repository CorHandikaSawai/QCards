import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qcards/screens/homepage_screen.dart';
import 'package:qcards/services/card_service.dart';
import 'package:qcards/widgets/card_form_widget.dart';

class EditCardsScreen extends StatefulWidget {
  const EditCardsScreen(
      {super.key, required this.cards, required this.subjectName});

  final List<Map<String, String>> cards;
  final String subjectName;

  @override
  State<EditCardsScreen> createState() => _EditCardsScreenState();
}

class _EditCardsScreenState extends State<EditCardsScreen> {
  ScrollController scrollController = ScrollController();
  List<CardFormWidget> listOfCards = [];

  @override
  void initState() {
    listOfCards.clear();
    for (var card in widget.cards) {
      listOfCards.add(CardFormWidget(
        initialQuestion: card['question'],
        initialAnswer: card['answer'],
        cardId: card['cardId'],
        isUpdated: false,
      ));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cardService = Provider.of<CardService>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePageScreen(),
                ),
                (route) => false);
          },
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
        title: Text('Editing ${widget.subjectName}'),
        centerTitle: true,
        actions: [
          Tab(
            child: TextButton(
              onPressed: () async {
                await cardService.updateCards(
                    userId: FirebaseAuth.instance.currentUser!.uid,
                    subjectName: widget.subjectName.toString(),
                    cards: listOfCards);
                if (mounted) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePageScreen(),
                      ),
                      (route) => false);
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
