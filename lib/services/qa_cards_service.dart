import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:free_quizme/widgets/qa_cards.dart';

class CardService {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  void getUserCollections({required String userId}) async {
    final docRef =
        await _firebaseFirestore.collection('subjects').doc(userId).get();
    print(docRef.metata.ad
  }

  saveAllCards(String collectionName, List<CardForm> cards) {
    cards.forEach((element) async {
      await _firebaseFirestore.collection(collectionName).add({
        element.questionFieldController.text: element.answerFieldController.text
      });
    });
  }
}
