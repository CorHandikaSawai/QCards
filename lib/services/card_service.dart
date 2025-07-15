import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:qcards/widgets/card_form_widget.dart';

/// CardService handles all Firestore operations related to:
/// - Collections (subjects)
/// - Cards (questions/answers)
/// - Sorting, saving, deleting, checking existence, etc.
class CardService extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;

  bool isLoading = false; // Used for UI loading states
  String error = ''; // Used to store error messages (if needed)

  /// 🔍 Returns a list of subject collections with their card count and lastUpdated time
  Future<List<Map<String, String>>> getUserSubjects({
    required String userId,
    required String sortValue,
  }) async {
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
            'count': element.get('count').toString(),
            'lastUpdated': element.get('lastUpdated'),
          });
        }

        // 🔠 Sorting based on dropdown value
        if (sortValue == "A-Z") {
          allSubjects.sort((a, b) => a['subjectName']!
              .toLowerCase()
              .compareTo(b['subjectName']!.toLowerCase()));
        } else if (sortValue == "Z-A") {
          allSubjects.sort((a, b) => b['subjectName']!
              .toLowerCase()
              .compareTo(a['subjectName']!.toLowerCase()));
        } else {
          allSubjects.sort((a, b) => b['lastUpdated']!
              .compareTo(a['lastUpdated']!)); // Most recent first
        }
      });
    } catch (e) {
      print("error: $e");
    }

    return allSubjects;
  }

  /// 🗑️ Delete entire subject collection and all its cards
  Future<void> deleteCollection({
    required String subjectName,
    required String userId,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      // Delete all cards inside the subject
      await _firestore
          .collection('collections')
          .doc(userId)
          .collection('subjects')
          .doc(subjectName)
          .collection('cards')
          .get()
          .then((value) async {
        for (var doc in value.docs) {
          await _firestore
              .collection('collections')
              .doc(userId)
              .collection('subjects')
              .doc(subjectName)
              .collection('cards')
              .doc(doc.id)
              .delete();
        }
      });

      // Delete the subject itself
      await _firestore
          .collection('collections')
          .doc(userId)
          .collection('subjects')
          .doc(subjectName)
          .delete();
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// 💾 Save all card forms entered by the user under a given subject
  Future<void> saveAllCards({
    required String userId,
    required String subjectName,
    required List<CardFormWidget> cards,
  }) async {
    error = '';
    isLoading = true;
    notifyListeners();

    int numOfCards = 0;

    try {
      for (var card in cards) {
        // Only save non-empty cards
        if (card.answerFieldController.text.isNotEmpty ||
            card.questionFieldController.text.isNotEmpty) {
          await _firestore
              .collection('collections')
              .doc(userId)
              .collection('subjects')
              .doc(subjectName)
              .collection('cards')
              .add({
            'question': card.questionFieldController.text,
            'answer': card.answerFieldController.text,
          });
        }
        numOfCards++;
      }

      // Update subject metadata
      if (numOfCards != 0) {
        await _firestore
            .collection('collections')
            .doc(userId)
            .collection('subjects')
            .doc(subjectName)
            .set({
          'count': numOfCards,
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

  /// 📥 Get all cards (question-answer pairs) under a subject
  Future<List<Map<String, String>>> getCardsFromSubject({
    required String userId,
    required String subjectName,
  }) async {
    List<Map<String, String>> questionsAnswers = [];

    try {
      await _firestore
          .collection('collections')
          .doc(userId)
          .collection('subjects')
          .doc(subjectName)
          .collection('cards')
          .get()
          .then((cards) {
        for (var card in cards.docs) {
          questionsAnswers.add({
            'question': card.get('question'),
            'answer': card.get('answer'),
            'cardId': card.id,
          });
        }
      });
    } catch (e) {
      print(e);
    }

    return questionsAnswers;
  }

  /// 📝 Update existing cards and add new ones based on their isUpdated flag
  Future<void> updateCards({
    required String userId,
    required String subjectName,
    required List<CardFormWidget> cards,
  }) async {
    error = '';
    isLoading = true;
    notifyListeners();

    int numOfCards = 0;

    try {
      for (var card in cards) {
        if (card.isUpdated == true) {
          // If updated but now blank, delete it
          if (card.questionFieldController.text == '' &&
              card.answerFieldController.text == '') {
            await deleteCard(
                userId: userId, subjectName: subjectName, card: card);
            continue;
          } else {
            // Update existing card
            await _firestore
                .collection('collections')
                .doc(userId)
                .collection('subjects')
                .doc(subjectName)
                .collection('cards')
                .doc(card.cardId)
                .set({
              'question': card.questionFieldController.text,
              'answer': card.answerFieldController.text,
            });
          }
        } else if (card.isUpdated == null) {
          // New card
          await _firestore
              .collection('collections')
              .doc(userId)
              .collection('subjects')
              .doc(subjectName)
              .collection('cards')
              .add({
            'question': card.questionFieldController.text,
            'answer': card.answerFieldController.text,
          });
        }

        numOfCards++;
      }

      // Update subject metadata
      if (numOfCards != 0) {
        await _firestore
            .collection('collections')
            .doc(userId)
            .collection('subjects')
            .doc(subjectName)
            .set({
          'count': numOfCards,
          'lastUpdated': DateTime.now().millisecondsSinceEpoch.toString(),
        });
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// 💾 Save a single card
  Future<void> saveCard({
    required String userId,
    required String subjectName,
    required CardFormWidget card,
  }) async {
    if (card.isUpdated == true) {
      await _firestore
          .collection('collections')
          .doc(userId)
          .collection('subjects')
          .doc(subjectName)
          .collection('cards')
          .doc(card.cardId)
          .set({
        'question': card.questionFieldController.text,
        'answer': card.answerFieldController.text,
      });
    }
  }

  /// ❌ Delete a single card and update count
  Future<void> deleteCard({
    required String userId,
    required String subjectName,
    required CardFormWidget card,
  }) async {
    await _firestore
        .collection('collections')
        .doc(userId)
        .collection('subjects')
        .doc(subjectName)
        .collection('cards')
        .doc(card.cardId)
        .delete()
        .then((_) async {
      await _firestore
          .collection('collections')
          .doc(userId)
          .collection('subjects')
          .doc(subjectName)
          .update({
        'count': FieldValue.increment(-1),
        'lastUpdated': DateTime.now().millisecondsSinceEpoch.toString(),
      });
    });
  }

  /// ✅ Check if a subject exists before saving or creating it
  Future<bool> exists({required String subjectName}) async {
    final subjectRef = await _firestore
        .collection('collections')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('subjects')
        .doc(subjectName)
        .get();

    return subjectRef.exists;
  }
}
