import 'package:flutter/material.dart';
import 'package:free_quizme/services/auth_service.dart';
import 'package:free_quizme/services/card_service.dart';
import 'package:free_quizme/widgets/flippable_card_widget.dart';
import 'package:provider/provider.dart';

class StudyScreen extends StatefulWidget {
  const StudyScreen(
      {super.key, required this.subjectName, required this.userId});

  final String subjectName;
  final String userId;

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  List<Widget> flippableCards = [];
  int _currentCardIndex = 0;

  void getCards() async {
    final cards = await CardService().getCardsFromSubject(
        userId: widget.userId, subjectName: widget.subjectName);
    if (cards.isNotEmpty) {
      for (var card in cards) {
        flippableCards.add(
          Visibility(
            visible: true,
            child: FlippableCardWidget(
              question: card['question']!,
              answer: card['answer']!,
            ),
          ),
        );
      }
    }
    setState(() {
      flippableCards;
    });
  }

  @override
  void initState() {
    super.initState();
    getCards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subjectName),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: flippableCards.isNotEmpty
                  ? flippableCards[_currentCardIndex]
                  : const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Ink(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                      ),
                      child: InkWell(
                        onTap: () => print('Left'), //TODO: Implement this
                        child: Icon(Icons.arrow_left),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Ink(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                      ),
                      child: InkWell(
                        onTap: () {
                          if (_currentCardIndex >= flippableCards.length - 1) {
                            setState(() {
                              _currentCardIndex = 0;
                            });
                          } else {
                            setState(() {
                              _currentCardIndex++;
                            });
                          }
                        },
                        child: Icon(Icons.arrow_right),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
