import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveUser(String uid, Map<String, dynamic> data) async {
    await _db.collection("users").doc(uid).set(
      {
        ...data,
        "updatedAt": FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }
  Future<Map<String, dynamic>?> getUser(String uid) async {
    final doc = await _db.collection("users").doc(uid).get();
    return doc.data();
  }
}