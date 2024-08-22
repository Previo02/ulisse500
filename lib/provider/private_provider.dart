import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PrivateProvider with ChangeNotifier {
  User? user;

  PrivateProvider() {
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
    updateUser(null);
  }

  void updateUser(User? newUser) {
    user = newUser;
    notifyListeners();
  }
}

