import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qcards/models/qc_user_model.dart';
import 'package:qcards/services/user_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService extends ChangeNotifier {
  final _firebaseAuth = FirebaseAuth.instance;
  final _userService = UserService();

  QCUser? currentUser;
  var isLoading = false;
  var isEmailVerified = false;
  var error = '';

  createUser(
      {required String firstName,
      required String lastName,
      required String email,
      required String password}) async {
    isLoading = true;
    error = '';
    notifyListeners();
    try {
      await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((UserCredential userCredential) =>
              userCredential.user!.sendEmailVerification().then((_) async {
                _userService.newUserData(
                    userId: userCredential.user!.uid,
                    firstName: firstName,
                    lastName: lastName);
                currentUser = await _userService.getUserData(
                    userId: userCredential.user!.uid);
              }));
    } on FirebaseAuthException catch (e) {
      const errorCodes = [
        'email-already-in-use',
        'invalid-email',
        'operation-not-allowed',
        'weak-password'
      ];
      if (errorCodes.contains(e.code)) {
        error =
            e.code[0].toUpperCase() + e.code.replaceAll('-', ' ').substring(1);
      } else {
        error = e.code;
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login({required String email, required String password}) async {
    isLoading = true;
    error = '';
    notifyListeners();
    try {
      await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((UserCredential userCredential) async {
        if (userCredential.user!.emailVerified) {
          currentUser =
              await _userService.getUserData(userId: userCredential.user!.uid);
        }
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        error =
            e.code[0].toUpperCase() + e.code.replaceAll('-', ' ').substring(1);
      } else if (e.code == 'user-disabled') {
        error = 'User is disabled. Please contact support.';
      } else {
        error = 'Incorrect email or password.';
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  ///Sign In with google
  Future<void> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((UserCredential userCredential) async {
        _userService.newUserData(
            userId: userCredential.user!.uid,
            firstName: userCredential.user!.email.toString(),
            lastName: '');
        currentUser =
            await _userService.getUserData(userId: userCredential.user!.uid);
      });
    } catch (e) {
      print(e);
    } finally {
      notifyListeners();
    }
  }

  Future<void> signInWithGoogleWeb() async {
    try {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      googleProvider
          .addScope('https://www.googleapis.com/auth/contacts.readonly');
      googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance
          .signInWithPopup(googleProvider)
          .then((UserCredential userCredential) async {
        _userService.newUserData(
            userId: userCredential.user!.uid,
            firstName: userCredential.user!.email.toString(),
            lastName: '');
        currentUser =
            await _userService.getUserData(userId: userCredential.user!.uid);
      });
    } catch (e) {
      print(e);
    } finally {
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
