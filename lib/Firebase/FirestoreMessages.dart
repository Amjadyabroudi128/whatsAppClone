import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> createUserInFirestore(User user) async {
  await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
    'email': user.email,
    'uid': user.uid,
    // 'online': true,
    // 'lastSeen': FieldValue.serverTimestamp(),
  }, SetOptions(merge: true));
}
