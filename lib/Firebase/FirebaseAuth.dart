import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
 class FirebaseService {
   final FirebaseAuth auth = FirebaseAuth.instance;
   Future<void> createEmailPassword(String email, String password) async {
     try {
       await auth.createUserWithEmailAndPassword(email: email, password: password);

     } on FirebaseAuthException catch (e) {
       String message = '';
       if (e.code == 'weak-password') {
         message = 'The password provided is too weak.';
       } else if (e.code == 'email-already-in-use') {
         message = 'An account already exists with that email.';
       }
       Fluttertoast.showToast(
         msg: message,
         toastLength: Toast.LENGTH_LONG,
         gravity: ToastGravity.SNACKBAR,
         backgroundColor: Colors.black54,
         textColor: Colors.white,
         fontSize: 14.0,
       );
     }
     catch (e){}

   }
   Future<void> SigninUser(BuildContext context, String email, String password) async {
     await auth.signInWithEmailAndPassword(email: email, password: password);
   }

   Future<void> SignOut ()async {
     auth.signOut();
  }
 }