import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:free_quizme/widgets/card_form_widget.dart';

class CardService extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  bool isLoading = false;

  ///Returns a list of map containing all subjects <subjectName, numOfCards>
  Future<List<Map<String, String>>> getUserSubjects(
      {required String userId}) async {
    List<Map<String, String>> allSubjects = [];
    try {
      await _firestore
          .collection('collections')
          .doc(userId)
          .collection('subjects')
          .get()
          .then((value) {
        for (var element in value.docs) {
          allSubjects
              .add({'subjectName': element.id, 'count': element.get('count')});
        }
      });
    } catch (e) {
      print(e);
    }
    return allSubjects;
  }

  ///Delete a subject containing questions and anwers
  Future<void> deleteCollection(
      {required String subjectName, required String userId}) async {
    isLoading = true;
    notifyListeners();
    try {
      await _firestore
          .collection('collections')
          .doc(userId)
          .collection('subjects')
          .doc(subjectName)
          .delete();
    } catch (e) {
      print(e);
    } finally {
      isLoading = true;
      notifyListeners();
    }
  }

  ///Saves all the questions and answers user has entered
  Future<void> saveAllCards(
      {required String userId,
      required String subjectName,
      required List<CardFormWidget> cards}) async {
    isLoading = true;
    notifyListeners();
    try {
      await _firestore
          .collection('collections')
          .doc(userId)
          .collection('subjects')
          .doc(subjectName)
          .set({'count': cards.length.toString()});

      for (var element in cards) {
        await _firestore
            .collection('collections')
            .doc(userId)
            .collection('subjects')
            .doc(subjectName)
            .collection('cards')
            .add({
          'question': element.questionFieldController.text,
          'answer': element.answerFieldController.text
        });
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  ///Returns a list of map containing all questions and answers from a specific subject <question, answer>
  Future<List<Map<String, String>>> getCardsFromSubject(
      {required String userId, required String subjectName}) async {
    List<Map<String, String>> questionsAnwers = [];
    try {
      await _firestore
          .collection('collections')
          .doc(userId)
          .collection('subjects')
          .doc(subjectName)
          .collection('cards')
          .get()
          .then(
        (cards) {
          for (var card in cards.docs) {
            questionsAnwers.add({
              'question': card.get('question'),
              'answer': card.get('answer'),
            });
          }
        },
      );
    } catch (e) {
      print(e);
    }
    return questionsAnwers;
  }
}
