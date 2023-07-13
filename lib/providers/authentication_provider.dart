// authentication_provider.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthenticationProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth;

  AuthenticationProvider(this._firebaseAuth);

  // Getter to check if user is currently signing in
  bool get isSigningIn {
    return _firebaseAuth.currentUser == null;
  }

  // Sign In Method
  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      notifyListeners(); // Notify listeners when sign in status changes
    } on FirebaseAuthException catch (e) {
      // handle error
      // ignore: avoid_print
      print(e);
    }
  }

  // Sign Out Method
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    notifyListeners(); // Notify listeners when sign out
  }

// Create Account Method
  Future<void> createAccount(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      notifyListeners(); // Notify listeners when sign in status changes
    } on FirebaseAuthException catch (e) {
      // handle error
      print('Error code: ${e.code}');
      print('Error message: ${e.message}');
    }
  }
}
