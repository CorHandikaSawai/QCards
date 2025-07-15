// Required imports
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qcards/screens/homepage_screen.dart';
import 'package:qcards/services/card_service.dart';
import 'package:qcards/widgets/card_form_widget.dart';

/// Screen for creating a new set of cards under a specific subject.
class CreateCardsScreen extends StatefulWidget {
  const CreateCardsScreen({super.key, required this.subjectName});

  /// Name of the subject/collection being created.
  final String? subjectName;

  @override
  State<CreateCardsScreen> createState() => _CreateCardsScreenState();
}

class _CreateCardsScreenState extends State<CreateCardsScreen> {
  // Scroll controller to automatically scroll to new card form
  ScrollController scrollController = ScrollController();

  // Initial list of card input widgets
  List<CardFormWidget> listOfCards = [CardFormWidget()];

  @override
  Widget build(BuildContext context) {
    // Access the CardService using Provider
    final cardService = Provider.of<CardService>(context);

    return Scaffold(
      // 🧠 App bar with Save action
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.subjectName.toString()),
        actions: [
          // Save button with loading state and error handling
          Tab(
            child: TextButton(
              onPressed: () async {
                await cardService
                    .saveAllCards(
                      userId: FirebaseAuth.instance.currentUser!.uid,
                      subjectName: widget.subjectName.toString(),
                      cards: listOfCards,
                    )
                    .then((_) => {
                          // Show error if it exists
                          if (cardService.error.isNotEmpty)
                            {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(cardService.error),
                                  backgroundColor: Colors.red[700],
                                ),
                              ),
                            }
                          // Navigate back to Home if successful
                          else if (mounted)
                            {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomePageScreen(),
                                ),
                                (route) => false,
                              )
                            }
                        });
              },

              // Show loading spinner if saving
              child: cardService.isLoading
                  ? const CircularProgressIndicator.adaptive(
                      backgroundColor: Colors.white,
                    )
                  : const Text(
                      'Save',
                      style: TextStyle(fontSize: 18),
                    ),
            ),
          )
        ],
      ),

      // 🧠 Body: Dynamic list of card form widgets
      body: SafeArea(
        child: Form(
          autovalidateMode: AutovalidateMode.always,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              verticalDirection:
                  VerticalDirection.up, // New cards appear at bottom
              children: listOfCards,
            ),
          ),
        ),
      ),

      // ➕ Floating button to add more card forms
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            listOfCards.add(CardFormWidget());
          });

          // Scroll to newly added card form
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
