import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qcards/models/qc_user_model.dart';
import 'package:qcards/services/user_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Handles all authentication-related operations and updates listening widgets.
class AuthenticationService extends ChangeNotifier {
  final _firebaseAuth = FirebaseAuth.instance;
  final _userService = UserService();

  // Stores the currently logged-in user's custom user model
  QCUser? currentUser;

  // Tracks loading state and error messages for UI updates
  var isLoading = false;
  var isEmailVerified = false;
  var error = '';

  /// Registers a new user using email/password and stores user profile in Firestore.
  Future<void> createUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    isLoading = true;
    error = '';
    notifyListeners(); // Trigger UI update

    try {
      await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((UserCredential userCredential) =>
              userCredential.user!.sendEmailVerification().then((_) async {
                // Save additional user info in Firestore
                await _userService.newUserData(
                  userId: userCredential.user!.uid,
                  firstName: firstName,
                  lastName: lastName,
                );

                // Retrieve and store user profile
                currentUser = await _userService.getUserData(
                    userId: userCredential.user!.uid);
              }));
    } on FirebaseAuthException catch (e) {
      // Translate known FirebaseAuth errors into friendly messages
      const errorCodes = [
        'email-already-in-use',
        'invalid-email',
        'operation-not-allowed',
        'weak-password',
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

  /// Logs in user using email/password, then fetches and stores user profile.
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
      // Handle common login errors
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

  /// Logs in user using Google Sign-In (Android/iOS/Desktop).
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((UserCredential userCredential) async {
        currentUser =
            await _userService.getUserData(userId: userCredential.user!.uid);

        // If first-time Google user, store profile in Firestore
        if (currentUser == null) {
          await _userService.newUserData(
            userId: userCredential.user!.uid,
            firstName: userCredential.user!.email.toString(),
            lastName: '',
          );
        }
      });
    } catch (e) {
      print(e);
    } finally {
      notifyListeners();
    }
  }

  /// Logs in user using Google Sign-In for Web (Flutter Web).
  Future<void> signInWithGoogleWeb() async {
    try {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      googleProvider
          .addScope('https://www.googleapis.com/auth/contacts.readonly');
      googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

      await FirebaseAuth.instance
          .signInWithPopup(googleProvider)
          .then((UserCredential userCredential) async {
        currentUser =
            await _userService.getUserData(userId: userCredential.user!.uid);

        // If new user, create record in Firestore
        if (currentUser == null) {
          await _userService.newUserData(
            userId: userCredential.user!.uid,
            firstName: userCredential.user!.email.toString(),
            lastName: '',
          );
        }
      });
    } catch (e) {
      print(e);
    } finally {
      notifyListeners();
    }
  }

  /// Logs out current user and resets stored user info.
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
      currentUser = null;
    } catch (e) {
      // TODO: Consider using a logging service
      print(e);
    } finally {
      notifyListeners();
    }
  }
}
