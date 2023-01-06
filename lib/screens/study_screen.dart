import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:free_quizme/services/auth_service.dart';
import 'package:free_quizme/services/card_service.dart';
import 'package:free_quizme/widgets/flippable_card_widget.dart';
import 'package:provider/provider.dart';

class StudyScreen extends StatefulWidget {
  const StudyScreen({super.key, required this.subjectName});

  final String subjectName;

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  int _currentCardIndex = 0;
  int _totalCards = 0;
  List<Widget> flippableCards = [];

  @override
  Widget build(BuildContext context) {
    final cardService = Provider.of<CardService>(context);
    final authService = Provider.of<AuthenticationService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subjectName),
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(8.0),
        child: Column(
          children: [
            FutureBuilder(
              future: cardService.getCardsFromSubject(
                  userId: 'YYhfgaVi4DPkf0rmdD3AL6p2C752', subjectName: 'eat'),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Map<String, String>>> snapshot) {
                if (snapshot.hasData) {
                  _totalCards = -1;
                  final cards = snapshot.data!;
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
                    _totalCards++;
                  }
                  return Expanded(
                    flex: 6,
                    child: flippableCards[_currentCardIndex],
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                return Text('No Data');
              },
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
                        onTap: () => print('Left'),
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
                          if (_currentCardIndex > _totalCards - 2) {
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
