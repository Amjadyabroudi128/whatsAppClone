import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/scaffoldMessanger.dart';
 class FirebaseService {
   final FirebaseAuth auth = FirebaseAuth.instance;
   Future<void> createEmailPassword(String email, String password) async {
     auth.createUserWithEmailAndPassword(email: email, password: password);
  }
   Future<void> SigninUser(BuildContext context, String email, String password) async {
     try {
       await auth.signInWithEmailAndPassword(email: email, password: password);
       showSnackbar(context, "Sign-in successful!");
     } on FirebaseAuthException catch (e) {
       if (e.code == "user-not-found") {
         showSnackbar(context, "User not registered. Please sign up.");
       } else if (e.code == "wrong-password") {
         showSnackbar(context, "Incorrect password. Try again.");
       } else if (e.code == "invalid-email") {
         showSnackbar(context, "Invalid email format.");
       } else {
         showSnackbar(context, "Error: ${e.message}");
       }
     }
   }
  Future<void> SignOut ()async {
     auth.signOut();
  }
 }