import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:ulisse500/classes/museum.dart';

class MuseumService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Museum> museums = [];

  Future<List<String>> getLockedMuseums() async {
    final User? user = _auth.currentUser;

    if (user != null) {
      final DocumentReference userDocRef =
          _firestore.collection('users').doc(user.uid);
      final DocumentSnapshot userDoc = await userDocRef.get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        if (data.containsKey('museums')) {
          return List<String>.from(data['museums'] ?? []);
        } else {
          return await _initializeMuseumsData(userDocRef);
        }
      } else {
        return await _initializeMuseumsData(userDocRef);
      }
    }
    return _getAllMuseumsIds();
  }

  Future<List<String>> _initializeMuseumsData(
      DocumentReference userDocRef) async {
    List<String> allMuseumsIds = _getAllMuseumsIds();
    await userDocRef.set({
      'museums': allMuseumsIds,
    });
    return allMuseumsIds;
  }

  Future<void> updateLockedMuseumStatus(List<String> lockedMuseumsIds) async {
    final User? user = _auth.currentUser;

    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'museums': lockedMuseumsIds,
      });
    }
  }

  List<String> _getAllMuseumsIds() {
    return ['0', '1', '2'];
  }

  Future<void> loadMuseumsFromJson() async {
    final String response =
        await rootBundle.loadString('assets/data/museums.json');
    final List<dynamic> data = json.decode(response);
    museums = data.map((json) => Museum.fromJson(json)).toList();
  }

  Future<List<String>> getUnlockedMuseums() async {
    final User? user = _auth.currentUser;
    List<String> returnList = _getAllMuseumsIds();

    if (user != null) {
      final DocumentReference userDocRef =
          _firestore.collection('users').doc(user.uid);
      final DocumentSnapshot userDoc = await userDocRef.get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        if (data.containsKey('museums')) {
          returnList.removeWhere(
              (item) => List<String>.from(data['museums']).contains(item));
          return returnList;
        } else {
          return List.empty();
        }
      } else {
        return List.empty();
      }
    }
    return List.empty();
  }
}
