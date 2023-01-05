import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:free_quizme/services/user_service.dart';
import 'package:free_quizme/widgets/card_form_widget.dart';

class CardService extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  bool isLoading = false;

  Future<List<Map<String, String>>> getUserCollections(
      {required String userId}) async {
    List<Map<String, String>> cardCollections = [];
    try {
      await _firestore
          .collection('collections')
          .doc(userId)
          .collection('subjects')
          .get()
          .then((value) {
        for (var element in value.docs) {
          cardCollections
              .add({'subjectName': element.id, 'count': element.get('count')});
        }
      });
    } catch (e) {
      print(e);
    }
    return cardCollections;
  }

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

  saveAllCards(
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
}
