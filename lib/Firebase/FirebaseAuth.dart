import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/scaffoldMessanger.dart';
 class FirebaseService {
   final FirebaseAuth auth = FirebaseAuth.instance;
   Future<void> createEmailPassword(String email, String password) async {
     auth.createUserWithEmailAndPassword(email: email, password: password);
  }
   Future<void> SigninUser(BuildContext context, String email, String password) async {
     await auth.signInWithEmailAndPassword(email: email, password: password);
   }

   Future<void> SignOut ()async {
     auth.signOut();
  }
 }