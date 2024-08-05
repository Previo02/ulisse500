import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
  User? user;

  AuthProvider() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      this.user = user;
      notifyListeners();
    });
  }

  bool get isAuthenticated {
    return user != null;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
