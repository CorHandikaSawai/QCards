import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:free_quizme/widgets/qa_cards.dart';

class CardService {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  saveAllCards(String collectionName, List<CardForm> cards) {
    DocumentReference? docRef = null;
    cards.forEach((element) async {
      docRef = await _firebaseFirestore.collection(collectionName).add({
        element.questionFieldController.text: element.answerFieldController.text
      });
    });
  }
}
