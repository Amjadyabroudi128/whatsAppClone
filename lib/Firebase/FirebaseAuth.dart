import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/flutterToast.dart';
import 'package:whatsappclone/messageClass/messageClass.dart';
import 'package:whatsappclone/utils/pickImage.dart' as url;
 class FirebaseService {
   final FirebaseAuth auth = FirebaseAuth.instance;
   final FirebaseFirestore users = FirebaseFirestore.instance;
   final uid = FirebaseAuth.instance.currentUser?.uid;
   Future<void> createEmailPassword(BuildContext context,String email, String password, String name) async {
     try {
       await auth.createUserWithEmailAndPassword(email: email, password: password);
       users.collection("users").doc(auth.currentUser!.uid).set({
         'email': email,
         'uid': auth.currentUser!.uid,
         "name" : name,
         'bio': '',
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
         "name" : name,
         "bio": "",
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

   Future<void> sendMessage(String receiverId, String receiverName, String message, String? image) async {
     final String currentUser = auth.currentUser!.uid;
     final String email = auth.currentUser!.email!;
     final Timestamp time = Timestamp.fromDate(DateTime.now());
     Messages newMessage = Messages(
       image: image,
       time: time,
       text: message,
       senderId: currentUser,
       receiverId: receiverId,
       senderEmail: email,
       receiverEmail: receiverName, // Store receiver's name
     );

     List<String> ids = [currentUser, receiverId];
     ids.sort();
     String chatRoomID = ids.join("_");

     await users.collection("chat_rooms").doc(chatRoomID)
         .collection("messages").add({
       ...newMessage.toMap(),
       "timestamp": FieldValue.serverTimestamp(),
     }).then((docRef) {
       // Store document ID
       docRef.update({"messageId": docRef.id});
     });
   }

   Stream <QuerySnapshot> getMessages(String userID, String otherUser) {
     List<String> ids = [userID, otherUser];
     ids.sort();
     String chatRoomID = ids.join("_");
     return users.collection("chat_rooms").doc(chatRoomID).collection("messages").orderBy("timestamp", descending: false).snapshots();
   }
   Future<void> checkUserLoggedIn(BuildContext context) async {
     User? user = auth.currentUser;
     if (user != null) {
       Navigator.pushReplacementNamed(context, "btm");
     } else {
       Navigator.pushReplacementNamed(context, "login");
     }
   }
   Future<void> Deletemessage(String userID, String receiverId, String messageId) async {
     List<String> ids = [userID, receiverId];
     ids.sort();
     String chatRoomID = ids.join("_");

     await FirebaseFirestore.instance
         .collection("chat_rooms")
         .doc(chatRoomID)
         .collection("messages")
         .doc(messageId) // Use the provided messageId
         .delete();
   }
   Future <void> updateMessage (String messageId, String userID, String receiverId, String newMessage) async {
     List<String> ids = [userID, receiverId];
     ids.sort();
     String chatRoomID = ids.join("_");
     await FirebaseFirestore.instance.collection("chat_rooms")
         .doc(chatRoomID).collection("messages").doc(messageId).update(
         {
           "message": newMessage,
         }
     );
   }
   Future<void> updateBio(newBio) async {
     if(uid != null) {
       await users.collection("users").doc(uid).update(
        {
          "bio": newBio,
        }
       );
     }
   }
   Future<String?> getBio() async {
     if (uid != null) {
       DocumentSnapshot doc =
       await users.collection("users").doc(uid).get();
       return doc['bio'] ?? "";
     }
     return null;
   }
 }