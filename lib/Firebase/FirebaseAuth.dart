import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/flutterToast.dart';
 class FirebaseService {
   final FirebaseAuth auth = FirebaseAuth.instance;
   final FirebaseFirestore users = FirebaseFirestore.instance;
   Future<void> createEmailPassword(BuildContext context,String email, String password, String name) async {
     try {
       await auth.createUserWithEmailAndPassword(email: email, password: password);
       users.collection("users").doc(auth.currentUser!.uid).set({
         'email': email,
         'uid': auth.currentUser!.uid,
         "name" : name,
       });
       await auth.currentUser?.reload();
       User? updatedUser = auth.currentUser;
       if (updatedUser != null) {
         Navigator.pushReplacementNamed(context, "btm"); // Ensure '/home' routes to contacts
       }
     } on FirebaseAuthException catch (e) {
       String message = '';
       if (e.code == 'weak-password') {
         message = 'The password provided is too weak.';
       } else if (e.code == 'email-already-in-use') {
         message = 'An account already exists with that email.';
       }
       myToast(message);
     }
     catch (e){}

   }
   Future<void> SigninUser(BuildContext context, String email, String password, String name) async {
     try {
       await auth.signInWithEmailAndPassword(email: email, password: password);
       users.collection("users").doc(auth.currentUser!.uid).set({
         'email': email,
         'uid': auth.currentUser!.uid,
         "name" : name
       });
       users.collection("users").get();
       await auth.currentUser?.reload();
       User? updatedUser = auth.currentUser;
       if (updatedUser != null) {
         Navigator.pushReplacementNamed(context, "btm"); // Ensure '/home' routes to contacts
       }
     } on FirebaseAuthException catch (e) {
       String message = '';
       if (e.code == 'user-not-found') {
         message = 'No user found for that email.';
       } else if (e.code == 'invalid-credential') {
         message = 'Wrong password provided for that user.';
       }
       myToast(message);
     }
     catch (e){}
   }

   Future<void> SignOut ()async {
     auth.signOut();
  }
  Future<void> deleteAccount () async{
    await users.collection("users").doc(auth.currentUser!.uid).delete();
    await FirebaseAuth.instance.currentUser?.delete();
  }
  Future<void> addMessage ({required senderName, required receiverName,}) async {
     users.collection("users").doc().collection("messages").add({
       "senderName": senderName,
       "receiverName": receiverName
     });
  }
 }