import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:free_quizme/models/qc_user_model.dart';
import 'package:free_quizme/services/user_service.dart';

class AuthenticationService extends ChangeNotifier {
  final _firebaseAuth = FirebaseAuth.instance;
  final _userService = UserService();

  QCUser? currentUser;
  var isLoading = false;
  var isEmailVerified = false;
  var response = '';

  createUser(
      {required String firstName,
      required String lastName,
      required String email,
      required String password}) async {
    isLoading = true;
    notifyListeners();
    try {
      await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((UserCredential userCredential) =>
              userCredential.user!.sendEmailVerification().then((_) {
                _userService.newUserData(
                    userId: userCredential.user!.uid,
                    firstName: firstName,
                    lastName: lastName);
                response = 'Successful. Please check your email.';
              }));
    } on FirebaseAuthException catch (e) {
      const errorCodes = [
        'email-already-in-use',
        'invalid-email',
        'operation-not-allowed',
        'weak-password'
      ];
      if (errorCodes.contains(e.code)) {
        response =
            e.code[0].toUpperCase() + e.code.replaceAll('-', ' ').substring(1);
      } else {
        response = e.code;
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login({required String email, required String password}) async {
    isLoading = true;
    notifyListeners();
    try {
      await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((UserCredential userCredential) async {
        if (userCredential.user!.emailVerified) {
          currentUser =
              await _userService.getUserData(userId: userCredential.user!.uid);
          response = 'Login Success';
        } else {
          response = 'Login Failed. Please verify your email';
        }
      });
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
      currentUser = null;
    } catch (e) {
      //TODO: Log error
      print(e);
    } finally {
      notifyListeners();
    }
  }
}
