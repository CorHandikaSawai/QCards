import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:free_quizme/widgets/qa_cards.dart';
import 'package:provider/provider.dart';

class CardService extends ChangeNotifier {
  final _firebaseFirestore = FirebaseFirestore.instance;
  Future<List<Map<String, String>>> get collections async {
    final cardCollection = await getUserCollections(userId: 'userId');
    return cardCollection;
  }

  Future<List<Map<String, String>>> getUserCollections(
      {required String userId}) async {
    List<Map<String, String>> cardCollections = [];
    final docRef = await _firebaseFirestore
        .collection('collections')
        .doc('userId')
        .collection('subjects')
        .get();

    for (var element in docRef.docs) {
      cardCollections
          .add({'subjectName': element.id, 'count': element.get('count')});
    }

    return cardCollections;
  }

  saveAllCards(String collectionName, List<CardForm> cards) {
    cards.forEach((element) async {
      await _firebaseFirestore.collection(collectionName).add({
        element.questionFieldController.text: element.answerFieldController.text
      });
    });
  }
}
