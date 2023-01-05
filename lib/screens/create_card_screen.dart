import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:free_quizme/screens/homepage_screen.dart';
import 'package:free_quizme/services/card_service.dart';
import 'package:free_quizme/widgets/card_form_widget.dart';
import 'package:provider/provider.dart';

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
            child: IconButton(
              onPressed: () {
                setState(() {
                  listOfCards.add(CardFormWidget());
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
            await cardService.saveAllCards(
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
          icon: cardService.isLoading
              ? const CircularProgressIndicator.adaptive()
              : const Icon(Icons.save),
        ),
      ),
    );
  }
}
