// authentication_provider.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthenticationProvider with ChangeNotifier  {
  final FirebaseAuth _firebaseAuth;

  AuthenticationProvider(this._firebaseAuth);

  // Getter to check if user is currently signing in
  bool get isSigningIn {
    return _firebaseAuth.currentUser == null;
  }

  // Sign In Method
 Future<String?> signIn(String email, String password) async {
  try {
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    notifyListeners(); // Notify listeners when sign in status changes
    return null;
  } on FirebaseAuthException catch (e) {
    return e.message; // Return the error message
  }
  }

  // Sign Out Method
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    notifyListeners(); // Notify listeners when sign out
  }

// Create Account Method
Future<String?> createAccount(String email, String password) async {
  try {
    await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    notifyListeners(); // Notify listeners when account is created
    return null;
  } on FirebaseAuthException catch (e) {
    return e.message; // Return the error message
  }
}
}
