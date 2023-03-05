import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:free_quizme/models/qc_user_model.dart';
import 'package:free_quizme/services/user_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
              userCredential.user!.sendEmailVerification().then((_) async {
                _userService.newUserData(
                    userId: userCredential.user!.uid,
                    firstName: firstName,
                    lastName: lastName);
                currentUser = await _userService.getUserData(
                    userId: userCredential.user!.uid);
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
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        response =
            e.code[0].toUpperCase() + e.code.replaceAll('-', ' ').substring(1);
      } else if (e.code == 'user-disabled') {
        response = 'User is disabled. Please contact support.';
      } else {
        response = 'Incorrect email or password.';
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  ///Sign In with google
  Future<void> signInWithGoogle() async {
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

    notifyListeners();
  }

  Future<void> signInWithGoogleWeb() async {
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

    notifyListeners();
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
