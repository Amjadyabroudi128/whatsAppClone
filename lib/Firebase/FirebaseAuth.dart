import 'package:firebase_auth/firebase_auth.dart';
 class FirebaseService {
   final FirebaseAuth auth = FirebaseAuth.instance;
   Future<void> createEmailPassword(String email, String password) async {
     auth.createUserWithEmailAndPassword(email: email, password: password);
  }
  Future<void> SigninUser(String email, String password) async {
     auth.signInWithEmailAndPassword(email: email, password: password);
  }
  Future<void> SignOut ()async {
     auth.signOut();
  }
 }