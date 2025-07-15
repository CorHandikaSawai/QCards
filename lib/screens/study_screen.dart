// Imports
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:qcards/services/card_service.dart';
import 'package:qcards/widgets/flippable_card_widget.dart';

/// Screen that allows users to study cards under a specific subject.
/// Cards are displayed one at a time with a flip interaction for Q&A.
class StudyScreen extends StatefulWidget {
  const StudyScreen({
    super.key,
    required this.subjectName,
    required this.userId,
  });

  /// The name of the subject/collection being studied
  final String subjectName;

  /// The ID of the current user (used to retrieve cards)
  final String userId;

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  /// The list of flippable card widgets to study
  List<FlippableCardWidget> flippableCards = [];

  /// Current card index in the deck
  int _currentCardIndex = 0;

  /// Fetches all cards for the given subject and populates the flippableCards list
  void getCards() async {
    final cards = await CardService().getCardsFromSubject(
      userId: widget.userId,
      subjectName: widget.subjectName,
    );

    if (cards.isNotEmpty) {
      for (var card in cards) {
        flippableCards.add(
          FlippableCardWidget(
            subjectName: widget.subjectName,
            cardId: card['cardId']!,
            question: card['question']!,
            answer: card['answer']!,
            flipCardKey: GlobalKey<FlipCardState>(),
          ),
        );
      }
    }

    // Triggers a rebuild to display the cards
    setState(() {
      flippableCards;
    });
  }

  /// Initial setup: Load cards when the screen is first displayed
  @override
  void initState() {
    super.initState();
    getCards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🧠 AppBar with subject name
      appBar: AppBar(
        title: Text(widget.subjectName),
      ),

      // 🧠 Main study layout
      body: SafeArea(
        minimum: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // 🔢 Card index indicator (e.g. 2 / 10)
            Text(
              '${_currentCardIndex + 1} / ${flippableCards.length}',
              style: const TextStyle(fontSize: 24),
            ),

            // 📄 Display current flashcard
            Expanded(
              flex: 6,
              child: flippableCards.isNotEmpty
                  ? flippableCards[_currentCardIndex]
                  : const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
            ),

            // 🔄 Navigation controls: Left/Right arrows
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ⬅️ Previous card
                  Expanded(
                    child: Ink(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.blue),
                      ),
                      child: InkWell(
                        onTap: () {
                          if (_currentCardIndex <= 0) {
                            _currentCardIndex = flippableCards.length - 1;
                          } else {
                            _currentCardIndex--;
                          }
                          setState(() {
                            flippableCards[_currentCardIndex];
                          });
                        },
                        child: const Icon(Icons.arrow_left),
                      ),
                    ),
                  ),

                  // ➡️ Next card
                  Expanded(
                    child: Ink(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.blue),
                      ),
                      child: InkWell(
                        onTap: () {
                          if (_currentCardIndex >= flippableCards.length - 1) {
                            _currentCardIndex = 0;
                          } else {
                            _currentCardIndex++;
                          }
                          setState(() {
                            flippableCards[_currentCardIndex];
                          });
                        },
                        child: const Icon(Icons.arrow_right),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
