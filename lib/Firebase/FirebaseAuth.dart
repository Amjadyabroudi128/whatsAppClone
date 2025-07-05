import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/flutterToast.dart';
import 'package:whatsappclone/messageClass/messageClass.dart';
import 'package:whatsappclone/utils/pickImage.dart' as url;
 class FirebaseService {
   final FirebaseAuth auth = FirebaseAuth.instance;
   final FirebaseFirestore users = FirebaseFirestore.instance;
   final uid = FirebaseAuth.instance.currentUser?.uid;
   final user = FirebaseAuth.instance.currentUser;

   Future<void> createEmailPassword(BuildContext context, String email, String password, String name) async {
     try {
       await auth.createUserWithEmailAndPassword(email: email, password: password);

       await auth.currentUser!.sendEmailVerification();

       // Save user data in Firestore
       await users.collection("users").doc(auth.currentUser!.uid).set({
         'email': email,
         'uid': auth.currentUser!.uid,
         'name': name,
         'bio': '',
         'image': '',
         'link': ''
       }, SetOptions(merge: true));
       Navigator.pushReplacementNamed(context, "login");
       myToast("Verification email sent. Please check your inbox.");
       // Sign out immediately after sending verification
       await auth.signOut();

     } on FirebaseAuthException catch (e) {
       String message = '';
       if (e.code == 'weak-password') {
         message = 'The password provided is too weak.';
       } else if (e.code == 'email-already-in-use') {
         message = 'An account already exists with that email.';
       }
       myToast(message);
     } catch (e) {
       print("Error during sign-up: $e");
     }
   }
   Future<void> SigninUser(BuildContext context, String email, String password, String name) async {
     try {
       await auth.signInWithEmailAndPassword(email: email, password: password);

       await auth.currentUser!.reload();
       User? user = auth.currentUser;

       if (user != null && user.emailVerified) {
         // Email is verified - proceed
         await users.collection("users").doc(user.uid).set({
           'email': email,
           'uid': user.uid,
           'name': name,
         }, SetOptions(merge: true));

         Navigator.pushReplacementNamed(context, "btm");
       } else {
         // Email not verified - sign out and prompt
         await auth.signOut();
         myToast("Please verify your email before signing in.");
       }

     } on FirebaseAuthException catch (e) {
       String message = '';
       if (e.code == 'user-not-found') {
         message = 'No user found for that email.';
       } else if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
         message = 'Wrong password provided.';
       }
       myToast(message);
     } catch (e) {
       print("Unexpected sign-in error: $e");
     }
   }
   Future<void> authenticate(String currentEmail, String newEmail, String password) async {
     final user = FirebaseAuth.instance.currentUser;
     if (password.isEmpty) {
       myToast("Add your password");
       return;
     }
     try {
       final cred = EmailAuthProvider.credential(email: currentEmail, password: password);
       await user!.reauthenticateWithCredential(cred);
       // Update Firestore
       await FirebaseFirestore.instance
           .collection("users")
           .doc(user.uid)
           .update({"email": newEmail});
       // Send verification to new email
       await user.verifyBeforeUpdateEmail(newEmail);
       myToast("A verification link was sent to your new email.");
     } on FirebaseAuthException catch (e) {
       if (e.code == 'wrong-password') {
         myToast("Password is incorrect");
       } else {
         myToast("Authentication failed: ${e.message}");
       }
     } catch (e) {
       myToast("An unexpected error occurred: $e");
     }
   }
   Future<void> resetPass(String email) async {
     auth.sendPasswordResetEmail(email: email);
     myToast("check your email for password");
   }
   Future<void> SignOut ()async {
     auth.signOut();
  }
   Future<void> deleteAccount() async {
     final user = FirebaseAuth.instance.currentUser;
     if (user == null) return;
     final uid = user.uid;
     final email = user.email;

     if (email == null) return;

     final firestore = FirebaseFirestore.instance;

     await firestore.collection("users").doc(uid).delete();
     final chatRoomsSnapshot = await firestore.collection("chat_rooms").get();
     for (var chatRoom in chatRoomsSnapshot.docs) {
       final messagesRef = chatRoom.reference.collection("messages");
       final messagesSnapshot =
       await messagesRef.where("senderEmail", isEqualTo: email).get();

       for (var msgDoc in messagesSnapshot.docs) {
         await msgDoc.reference.delete();
       }
     }
     final starredMessagesRef =
     firestore.collection("starred-messages").doc(email);

     final starredMessagesSnapshot =
     await starredMessagesRef.collection("messages").get();

     for (var doc in starredMessagesSnapshot.docs) {
       await doc.reference.delete();
     }

     await starredMessagesRef.delete();
     await user.delete();
   }


   Future<void> sendMessage(String receiverId, String receiverName, String message, String? image, String? file, Messages? replyTo) async {
     final String currentUser = auth.currentUser!.uid;
     final String email = auth.currentUser!.email!;
     final Timestamp time = Timestamp.fromDate(DateTime.now());

     Messages newMessage = Messages(
       image: image,
       file: file,
       time: time,
       text: message,
       senderId: currentUser,
       receiverId: receiverId,
       senderEmail: email,
       receiverEmail: receiverName, // Store receiver's name
       isEdited: false,
       isStarred: false,
       isReply: replyTo !=null,
       replyTo : replyTo
     );

     List<String> ids = [currentUser, receiverId];
     ids.sort();
     String chatRoomID = ids.join("_");
     final docRef = await users
         .collection("chat_rooms")
         .doc(chatRoomID)
         .collection("messages")
         .add({
       ...newMessage.toMap(),
       "timestamp": FieldValue.serverTimestamp(),
     });

     await docRef.update({"messageId": docRef.id});
     await users.collection("chat_rooms").doc(chatRoomID).set({
       "participants": [currentUser, receiverId],
       "lastMessage": message.isNotEmpty
           ? message
           : image != null
           ? "[Image]"
           : file != null
           ? "[File]"
           : "",
       "lastMessageTime": time,
       "lastMessageSender": currentUser,
       "receiverName": receiverName,
       "lastMessageType": image != null ? "image" : file != null ? "file" : "text",
     }, SetOptions(merge: true));
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
   Future<void> Deletemessage( String senderID, String receiverId, String messageId,) async {
     List<String> ids = [senderID, receiverId];
     ids.sort();
     String chatRoomID = ids.join("_");
     await FirebaseFirestore.instance.collection("chat_rooms").doc(chatRoomID).collection("messages").doc(messageId).delete();
     await FirebaseFirestore.instance.collection("starred-messages")
         .doc(auth.currentUser!.email).collection("messages").doc(messageId).delete();
   }
   Future<void> deleteSelectedMessages({
     required String senderId,
     required String receiverId,
     required Set<String> messageIds,
   }) async {
     final batch = FirebaseFirestore.instance.batch();
     List<String> ids = [senderId, receiverId];
     ids.sort();
     String chatRoomID = ids.join("_");

     for (String messageId in messageIds) {
       // Delete from chat messages
       final msgRef = FirebaseFirestore.instance
           .collection("chat_rooms")
           .doc(chatRoomID)
           .collection("messages")
           .doc(messageId);

       batch.delete(msgRef);
       // Delete from starred messages
       final starredRef = FirebaseFirestore.instance
           .collection("starred-messages")
           .doc(FirebaseAuth.instance.currentUser!.email)
           .collection("messages")
           .doc(messageId);
       batch.delete(starredRef);
     }
     await batch.commit();
   }

   Future <void> updateMessage (String messageId, String userID, String receiverId, String newMessage) async {
     List<String> ids = [userID, receiverId];
     ids.sort();
     String chatRoomID = ids.join("_");
     await FirebaseFirestore.instance.collection("chat_rooms")
         .doc(chatRoomID).collection("messages").doc(messageId).update(
         {
           "message": newMessage,
           "isEdited": true,
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
   Future<void> updateName(newName) async {
     if(uid != null) {
       await users.collection("users").doc(uid).update(
         {
         "name": newName
         }
       );
     }
   }
   Future<void> addLink(newLink) async {
     if(uid != null) {
       await users.collection("users").doc(uid).update(
           {
             "link": newLink
           }
       );
     }
   }
   Future addToStar(Messages msg) async {
     String email = auth.currentUser!.email!;
     String messageId = msg.messageId!;
     List<String> ids = [msg.senderId!, msg.receiverId!];
     ids.sort();
     String chatRoomID = ids.join("_");
     // Add to personal starred collection ONLY
     await FirebaseFirestore.instance
         .collection("starred-messages")
         .doc(email)
         .collection("messages")
         .doc(messageId)
         .set({
       "message": msg.text,
       "timestamp": msg.time,
       "senderEmail": msg.senderEmail,
       "receiverId": msg.receiverId,
       "messageId": messageId,
       "senderId": msg.senderId,
       "image": msg.image ?? "",
       "isStarred": true
     });

     await FirebaseFirestore.instance
         .collection("chat_rooms")
         .doc(chatRoomID)
         .collection("messages")
         .doc(messageId)
         .update({"isStarred": true});
   }
   Future deleteStar(Messages msg) async {
     String email = auth.currentUser!.email!;
     String messageId = msg.messageId!;
     List<String> ids = [msg.senderId!, msg.receiverId!];
     ids.sort();
     String chatRoomID = ids.join("_");
     await FirebaseFirestore.instance
         .collection("starred-messages")
         .doc(email)
         .collection("messages")
         .doc(messageId)
         .delete();
     await FirebaseFirestore.instance
         .collection("chat_rooms")
         .doc(chatRoomID)
         .collection("messages")
         .doc(messageId)
         .update({"isStarred": false});

   }


   Stream<QuerySnapshot> getRecentChats(String userId) {
     return FirebaseFirestore.instance
         .collection("chat_rooms")
         .where("participants", arrayContains: userId)
         .orderBy("lastMessageTime", descending: true)
         .snapshots();
   }

 }