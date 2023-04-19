import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:qcards/widgets/card_form_widget.dart';

class CardService extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  bool isLoading = false;
  String error = '';

  ///Returns a list of map containing all subjects <subjectName, numOfCards>
  Future<List<Map<String, String>>> getUserSubjects(
      {required String userId, required String sortValue}) async {
    List<Map<String, String>> allSubjects = [];
    try {
      await _firestore
          .collection('collections')
          .doc(userId)
          .collection('subjects')
          .get()
          .then((value) {
        for (var element in value.docs) {
          allSubjects.add({
            'subjectName': element.id,
            'count': element.get('count'),
            'lastUpdated': element.get('lastUpdated'),
          });
        }
        if (sortValue == "A-Z") {
          allSubjects.sort(((a, b) => a['subjectName']!
              .toLowerCase()
              .compareTo(b['subjectName']!.toLowerCase())));
        } else if (sortValue == "Z-A") {
          allSubjects.sort(((a, b) => b['subjectName']!
              .toLowerCase()
              .compareTo(a['subjectName']!.toLowerCase())));
        } else {
          allSubjects.sort(((a, b) => b['lastUpdated']!
              .toLowerCase()
              .compareTo(a['lastUpdated']!.toLowerCase())));
        }
      });
    } catch (e) {
      print("error: $e");
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
          .collection('cards')
          .get()
          .then((value) async => {
                for (var doc in value.docs)
                  {
                    await _firestore
                        .collection('collections')
                        .doc(userId)
                        .collection('subjects')
                        .doc(subjectName)
                        .collection('cards')
                        .doc(doc.id)
                        .delete()
                  }
              });
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

  ///Saves all the questions and answers user has entered to the collection
  Future<void> saveAllCards(
      {required String userId,
      required String subjectName,
      required List<CardFormWidget> cards}) async {
    error = '';
    isLoading = true;
    notifyListeners();
    int numOfCards = 0;
    try {
      for (var card in cards) {
        //Only save cards that are not completely empty
        if (card.answerFieldController.text.isNotEmpty ||
            card.questionFieldController.text.isNotEmpty) {
          //New cards
          await _firestore
              .collection('collections')
              .doc(userId)
              .collection('subjects')
              .doc(subjectName)
              .collection('cards')
              .add({
            'question': card.questionFieldController.text,
            'answer': card.answerFieldController.text
          });
        }
        numOfCards++;
      }
      //Card counts
      if (numOfCards != 0) {
        await _firestore
            .collection('collections')
            .doc(userId)
            .collection('subjects')
            .doc(subjectName)
            .set({
          'count': numOfCards.toString(),
          'lastUpdated': DateTime.now().millisecondsSinceEpoch.toString(),
        });
      } else {
        await deleteCollection(subjectName: subjectName, userId: userId);
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
              'cardId': card.id
            });
          }
        },
      );
    } catch (e) {
      print(e);
    }
    return questionsAnwers;
  }

  //Update cards
  Future<void> updateCards(
      {required String userId,
      required String subjectName,
      required List<CardFormWidget> cards}) async {
    int numOfCards = 0;
    for (var card in cards) {
      if (card.isUpdated == true) {
        _firestore
            .collection('collections')
            .doc(userId)
            .collection('subjects')
            .doc(subjectName)
            .collection('cards')
            .doc(card.cardId)
            .set({
          'question': card.questionFieldController.text,
          'answer': card.answerFieldController.text
        });
      } else {
        if (card.isUpdated == null) {
          await _firestore
              .collection('collections')
              .doc(userId)
              .collection('subjects')
              .doc(subjectName)
              .collection('cards')
              .add({
            'question': card.questionFieldController.text,
            'answer': card.answerFieldController.text
          });
        }
      }
      numOfCards++;
    }
    if (numOfCards != 0) {
      await _firestore
          .collection('collections')
          .doc(userId)
          .collection('subjects')
          .doc(subjectName)
          .set({
        'count': numOfCards.toString(),
        'lastUpdated': DateTime.now().millisecondsSinceEpoch.toString(),
      });
    }
  }

  Future<bool> exists({required String subjectName}) async {
    final subjectRef = await _firestore
        .collection('collections')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('subjects')
        .doc(subjectName)
        .get();
    if (subjectRef.exists) {
      return true;
    }
    return false;
  }
}
