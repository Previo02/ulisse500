import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ulisse500/classes/dinosaur.dart';

class DinosaurService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Dinosaur> dinosaurs = [
    Dinosaur(
      id: '0',
      name: 'Tyrannosaurus Rex',
      image: 'assets/images/trex.png',
      description: 'Il Tyrannosaurus Rex è uno dei dinosauri più famosi...',
    ),
    Dinosaur(
      id: '1',
      name: 'Triceratops',
      image: 'assets/images/triceratops.png',
      description: 'Il Triceratops è conosciuto per le sue tre corna...',
    ),
  ];

  Future<List<String>> getLockedDinosaurs() async {
    final User? user = _auth.currentUser;

    if (user != null) {
      final DocumentReference userDocRef =
          _firestore.collection('users').doc(user.uid);
      final DocumentSnapshot userDoc = await userDocRef.get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        if (data.containsKey('dinosaurs')) {
          return List<String>.from(data['dinosaurs'] ?? []);
        } else {
          return await _initializeDinosaurData(userDocRef);
        }
      } else {
        return await _initializeDinosaurData(userDocRef);
      }
    }
    return _getAllDinosaurIds();
  }
  
  Future<void> updateLockedDinosaurStatus(
      List<String> lockedDinosaurIds) async {
    final User? user = _auth.currentUser;

    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'dinosaurs': lockedDinosaurIds,
      });
    }
  }

  Future<List<String>> _initializeDinosaurData(
      DocumentReference userDocRef) async {
    List<String> allDinosaurIds = _getAllDinosaurIds();
    await userDocRef.set({
      'dinosaurs': allDinosaurIds,
    });
    return allDinosaurIds;
  }

  List<String> _getAllDinosaurIds() {
    return ['0', '1'];
  }
}
