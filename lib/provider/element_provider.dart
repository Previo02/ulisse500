import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DinosaurService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> getLockedDinosaurs() async {
    final User? user = _auth.currentUser;

    if (user != null) {
      final DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('dinosaurs')
          .doc('dinosaurStatus')
          .get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        return List<String>.from(data['lockedDinosaurIds'] ?? []);
      }
    }
    return [];
  }

  Future<void> updateLockedDinosaurStatus(
      List<String> lockedDinosaurIds) async {
    final User? user = _auth.currentUser;

    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('dinosaurs')
          .doc('dinosaurStatus')
          .set({
        'lockedDinosaurIds': lockedDinosaurIds,
      });
    }
  }
}
