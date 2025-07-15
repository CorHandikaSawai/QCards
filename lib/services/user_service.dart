import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:qcards/models/qc_user_model.dart';

/// A service that handles Firestore operations related to the user.
class UserService extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;

  /// Creates a new user document in Firestore.
  ///
  /// Stores the [firstName] and [lastName] under the given [userId].
  newUserData({
    required String userId,
    required String firstName,
    required String lastName,
  }) {
    _firestore.collection('users').doc(userId).set({
      'firstName': firstName,
      'lastName': lastName,
    });
  }

  /// Retrieves user data from Firestore by [userId].
  ///
  /// Returns a [QCUser] object with the fetched data.
  Future<QCUser> getUserData({required String userId}) async {
    final docRef = await _firestore.collection('users').doc(userId).get();

    final String fName = docRef.get('firstName');
    final String lName = docRef.get('lastName');

    return QCUser(
      userId: userId,
      firstName: fName,
      lastName: lName,
    );
  }
}
