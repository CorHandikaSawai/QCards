import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:free_quizme/models/qc_user_model.dart';

class UserService extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;

  newUserData(
      {required String userId,
      required String firstName,
      required String lastName}) {
    _firestore.collection('users').doc(userId).set({
      'firstName': firstName,
      'lastName': lastName,
    });
  }

  Future<QCUser> getUserData({required String userId}) async {
    final docRef = await _firestore.collection('users').doc(userId).get();
    final String fName = docRef.get('firstName');
    final String lName = docRef.get('lastName');
    final currentUser =
        QCUser(userId: userId, firstName: fName, lastName: lName);
    return currentUser;
  }
}
