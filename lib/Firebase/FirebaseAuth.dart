import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/flutterToast.dart';
import 'package:whatsappclone/messageClass/messageClass.dart';
import 'package:whatsappclone/utils/pickImage.dart' as url;
import 'package:http/http.dart' as http;
import 'package:cloud_functions/cloud_functions.dart';
 class FirebaseService {
   final FirebaseAuth auth = FirebaseAuth.instance;
   final FirebaseFirestore users = FirebaseFirestore.instance;
   final uid = FirebaseAuth.instance.currentUser?.uid;
   final user = FirebaseAuth.instance.currentUser;

   Future<void> createEmailPassword(BuildContext context, String email, String password, String name) async {
     try {
       await auth.createUserWithEmailAndPassword(email: email, password: password);

       await auth.currentUser!.sendEmailVerification();
       await auth.currentUser!.updateDisplayName(name);

// Refresh the user to make displayName available
       await auth.currentUser!.reload();
       // Save user data in Firestore
       await users.collection("users").doc(auth.currentUser!.uid).set({
         'email': email,
         'uid': auth.currentUser!.uid,
         'name': name,
         'bio': '',
         'image': '',
         'link': ''
       }, SetOptions(merge: true));
       await saveFcmTokenToFirestore();
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
       } else if (e.code == 'invalid-email') {
         message = 'The email address is not valid.';
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
         await auth.currentUser!.updateDisplayName(name);
         await users.collection("users").doc(user.uid).update({
           'email': email,
           'name': name,
         });
         await saveFcmTokenToFirestore(); // ✅ await to avoid warning and run it properly
         Navigator.pushReplacementNamed(context, "btm");
       } else {
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

   Future <void> saveFcmTokenToFirestore() async {
     final user = FirebaseAuth.instance.currentUser;
     final token = await FirebaseMessaging.instance.getToken();

     if (user != null && token != null) {
       await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
         'fcmToken': token,
       });
       print("✅ FCM token saved for ${user.uid}");
     }
   }
   Future<void> deleteRecentChat(String chatRoomId, BuildContext context) async {
     try {
       // Delete all messages in the chat room
       final messages = await FirebaseFirestore.instance
           .collection("chat_rooms")
           .doc(chatRoomId)
           .collection("messages")
           .get();

       for(var doc in messages.docs) {
         await doc.reference.delete();
       }
       await FirebaseFirestore.instance
           .collection("chat_rooms")
           .doc(chatRoomId)
           .delete();
       Navigator.of(context).pop();
       myToast("Message Successfully Deleted");
       FocusScope.of(context).unfocus();
     } catch (e) {
       myToast("Failed to delete chat: $e");
     }
   }

   Future<void> sendMessage(
       String receiverId,
       String receiverName,
       String message,
       String? image,
       String? file,
       Messages? replyTo,
       ) async {
     final String currentUser = auth.currentUser!.uid;
     final String email = auth.currentUser!.email!;
     final String name = auth.currentUser!.displayName ?? "Unknown";
     final Timestamp time = Timestamp.fromDate(DateTime.now());
     Messages newMessage = Messages(
       image: image ?? "",
       file: file ?? "",
       time: time,
       text: message,
       senderId: currentUser,
       receiverId: receiverId,
       senderEmail: email,
       receiverEmail: receiverName,
       senderName: name,
       isEdited: false,
       isStarred: false,
       isRead: false, // ✅ ADD THIS
       isReply: replyTo != null,
       replyTo: replyTo,
     );

     List<String> ids = [currentUser, receiverId];
     ids.sort();
     String chatRoomID = ids.join("_");

     // Save message
     final docRef = await users
         .collection("chat_rooms")
         .doc(chatRoomID)
         .collection("messages")
         .add({
       ...newMessage.toMap(),
       "timestamp": FieldValue.serverTimestamp(),
     });

     await docRef.update({"messageId": docRef.id});

     // Update chat metadata
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
       "lastMessageType": image != null
           ? "image"
           : file != null
           ? "file"
           : "text",
     }, SetOptions(merge: true));

     // 🔥 Get receiver's FCM token
     final receiverDoc = await FirebaseFirestore.instance
         .collection('users')
         .doc(receiverId)
         .get();

     final receiverToken = receiverDoc.data()?['fcmToken'];

     if (receiverToken == null) {
       print('❌ No FCM token found for receiver: $receiverId');
       return;
     }

     // ✅ Call the push notification function
     final previewText = message.isNotEmpty
         ? message
         : image != null
         ? "📷 Sent an image"
         : file != null
         ? "📎 Sent a file"
         : auth.currentUser!.displayName!.isEmpty ? "new Message" : "${name} sent a message";
     // print("new mewssage from ${auth.currentUser!.email}");

     print("📨 Sending notification to: $receiverName ($receiverToken)");
     print("$message");
     await sendPushNotificationViaFunction(
       token: receiverToken,
       title: auth.currentUser!.displayName!.isEmpty ? "new Message" : "${name} sent a message",
       body: previewText,
       receiverId: receiverId,
       receiverName: receiverName,
       image: image,
       type: "chat"
     );

   }

   Future<void> sendPushNotificationViaFunction({
     required String token,
     required String title,
     required String body,
     String? receiverId,
     String? receiverName,
     String? image,
     String? type,
   }) async {
     try {
       final data = {
         'token': token,
         'title': title,
         'body': body,
         'receiverId': receiverId ?? '',
         'receiverName': receiverName ?? '',
         'image': image ?? '',
         'type': type ?? 'chat',

       };
       final callable = FirebaseFunctions.instanceFor(region: 'europe-west1').httpsCallable('sendNotification');
       final result = await callable.call(data);
       print("✅ FCM sent: ${result.data}");
       print("➡️ Navigating to chat with $receiverName ($receiverId)");
     } catch (e) {
       print("❌ Error calling sendNotification: $e");
     }
   }


   Future<String?> getReceiverFcmToken(String receiverId) async {
     final doc = await FirebaseFirestore.instance.collection('users').doc(receiverId).get();
     if (doc.exists && doc.data()!.containsKey('fcmToken')) {
       return doc['fcmToken'];
     } else {
       print('❌ No FCM token found for receiver: $receiverId');
       return null;
     }
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
   Future<void> readMsg(String? receiverId) async {
     final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

     if (receiverId == null) return;

     // Build chatRoomID from both user IDs
     List<String> ids = [currentUserId, receiverId];
     ids.sort();
     String chatRoomID = ids.join("_");

     final messagesRef = FirebaseFirestore.instance
         .collection("chat_rooms")
         .doc(chatRoomID)
         .collection("messages");

     // Query unread messages received by current user
     final unreadMessagesQuery = await messagesRef
         .where("receiverId", isEqualTo: currentUserId)
         .where("isRead", isEqualTo: false)
         .get();
     for (final doc in unreadMessagesQuery.docs) {
       await doc.reference.update({"isRead": true});
     }
   }
   Future<void> unread(String receiverId) async  {
     final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
     List<String> ids = [currentUserId, receiverId];
     ids.sort();
     String chatRoomID = ids.join("_");
     final messagesRef = FirebaseFirestore.instance
         .collection("chat_rooms")
         .doc(chatRoomID)
         .collection("messages");
     final messageRead = await messagesRef.where("receiverId", isEqualTo: currentUserId)
         .where("isRead", isEqualTo: true).orderBy("timestamp", descending: true).limit(1).get();
     for (var doc in messageRead.docs) {
       await doc.reference.update({
         "isRead": false
       });
     }
   }
   Stream<int> getTotalUnreadCount(String userId) {
     return FirebaseFirestore.instance
         .collectionGroup("messages")
         .where("receiverId", isEqualTo: userId)
         .where("isRead", isEqualTo: false)
         .snapshots()
         .map((snapshot) => snapshot.docs.length);
   }
   // Stream<int> getTotalUnreadMessages(String? receiverId) {
   //   final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
   //   List<String> ids = [currentUserId, receiverId!];
   //   ids.sort();
   //   String chatRoomID = ids.join("_");
   //
   //   return FirebaseFirestore.instance
   //       .collection("chat_rooms")
   //       .doc(chatRoomID)
   //       .collection("messages")
   //       .where("receieverId", isEqualTo: currentUserId)
   //       .where("isRead", isEqualTo: false)
   //       .snapshots()
   //       .map((snapshot) {
   //     return snapshot.docs
   //         .where((doc) => doc.data()['senderId'] != currentUserId)
   //         .length;
   //   });
   // }


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
   Future<List<Messages>> getAllLastMessages() async {
     final currentUser = FirebaseAuth.instance.currentUser;
     if (currentUser == null) return [];

     final chatRooms = await users
         .collection("chat_rooms")
         .where("participants", arrayContains: currentUser.uid) // ✅ only relevant rooms
         .get();

     List<Messages> recentMessages = [];

     for (var room in chatRooms.docs) {
       final messagesSnap = await room.reference
           .collection("messages")
           .orderBy("timestamp", descending: true)
           .limit(1)
           .get();

       if (messagesSnap.docs.isNotEmpty) {
         final doc = messagesSnap.docs.first;
         final data = doc.data();
         final message = Messages(
           text: data["message"],
           senderId: data["senderId"],
           senderName: data["senderName"],
           receiverId: data["receiverId"],
           senderEmail: data["senderEmail"],
           receiverEmail: data["receiverEmail"],
           time: data["timestamp"],
           image: data["image"] ?? "",
           file: data["file"] ?? "",
           messageId: doc.id,
           isEdited: data["isEdited"] ?? false,
           isStarred: data["isStarred"] ?? false,
           isReply: data["isReply"] ?? false,
           replyTo: data["replyTo"] != null
               ? Messages.fromMap(Map<String, dynamic>.from(data["replyTo"]))
               : null,
         );
         recentMessages.add(message);
       }
     }

     return recentMessages;
   }

 }