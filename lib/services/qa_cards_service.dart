import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:free_quizme/widgets/qa_cards.dart';

class CardService extends ChangeNotifier {
  final _firebaseFirestore = FirebaseFirestore.instance;
  List<Map<String, String>> cardCollections = [];

  Future<List<Map<String, String>>> get collections async {
    await getUserCollections(userId: 'userId');
    return cardCollections;
  }

  Future<void> getUserCollections({required String userId}) async {
    final docRef = await _firebaseFirestore
        .collection('collections')
        .doc('userId')
        .collection('subjects')
        .get()
        .then((value) {
      for (var element in value.docs) {
        cardCollections
            .add({'subjectName': element.id, 'count': element.get('count')});
      }
    });
  }

  saveAllCards(String collectionName, List<CardForm> cards) async {
    await _firebaseFirestore
        .collection('collections')
        .doc('userId')
        .collection('subjects')
        .doc(collectionName)
        .set({'count': cards.length.toString()});

    for (var element in cards) {
      await _firebaseFirestore
          .collection('collections')
          .doc('userId')
          .collection('subjects')
          .doc(collectionName)
          .collection('cards')
          .add({
        'question': element.questionFieldController.text,
        'answer': element.answerFieldController.text
      });
    }
  }
}
