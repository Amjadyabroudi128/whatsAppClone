
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:whatsappclone/components/flutterToast.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../features/chatScreen/Model/MessageModel.dart';
import '../features/contacts/Model/UserModel.dart';
 class FirebaseService {
   final FirebaseAuth auth = FirebaseAuth.instance;
   final FirebaseFirestore users = FirebaseFirestore.instance;
   final uid = FirebaseAuth.instance.currentUser?.uid;
   final user = FirebaseAuth.instance.currentUser;
   final GoogleSignIn _googleSignIn = GoogleSignIn();

   Future<void> createEmailPassword(BuildContext context, String email, String password, String name) async {
     try {
       await auth.createUserWithEmailAndPassword(email: email, password: password);

       await auth.currentUser!.sendEmailVerification();
       await auth.currentUser!.updateDisplayName(name);


       await auth.currentUser!.reload();
       // Save user data in Firestore
       await users.collection("users").doc(auth.currentUser!.uid).set({
         'email': email,
         'uid': auth.currentUser!.uid,
         'name': name,
         'bio': '',
         'image': '',
         'link': '',
          "isOnline": true,
         "lastSeen": FieldValue.serverTimestamp()
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
       debugPrint("Error during sign-up: $e");
     }
   }
   Future<void> setOnlineVisibility(String option) async {
     final u = FirebaseAuth.instance.currentUser;
     if (u == null) return;
     await FirebaseFirestore.instance
         .collection('users')
         .doc(u.uid)
         .set({'onlineVisibility': option}, SetOptions(merge: true));
   }
   Future<void> bioVisibility(String option)async {
     final u = FirebaseAuth.instance.currentUser;
     if (u == null) return;
     await FirebaseFirestore.instance
         .collection('users')
         .doc(u.uid)
         .set({'BioVisibility': option}, SetOptions(merge: true));
   }
   Future<void> imageVisibility(String option) async {
     final u = FirebaseAuth.instance.currentUser;
     if (u == null) return;
     await FirebaseFirestore.instance
         .collection('users')
         .doc(u.uid)
         .set({'imageVisibility': option}, SetOptions(merge: true));
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
           'isOnline': true,
           'lastSeen': FieldValue.serverTimestamp(),
         });
         await saveFcmTokenToFirestore(); // await to avoid warning and run it properly
         Navigator.pushReplacementNamed(context, "btm");
       } else {
         await onlineStatues(false);
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

   Future<void> signInWithGoogle(BuildContext context) async {
     try {
       final GoogleSignInAccount? gUser = await _googleSignIn.signIn();

       if (gUser == null) {
         return;
       }
       final GoogleSignInAuthentication gAuth = await gUser.authentication;
       final cred = GoogleAuthProvider.credential(
         idToken: gAuth.idToken,
         accessToken: gAuth.accessToken,
       );

       await FirebaseAuth.instance.signInWithCredential(cred);
       Navigator.pushReplacementNamed(context, "btm");
       await Future.delayed(const Duration(seconds: 1));

     } catch (e) {
       print('Error signing in with Google: $e');
       // Handle error appropriately
     }
   }
   Future<void> SignOut ()async {
     await onlineStatues(false);
     auth.signOut();
     _googleSignIn.disconnect();

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
       print(" FCM token saved for ${user.uid}");
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
   Future<void> markImageAsViewed({
     required String senderId,
     required String receiverId,
     required String messageId,
   }) async {
     List<String> ids = [senderId, receiverId];
     ids.sort();
     String chatRoomID = ids.join("_");

     try {
       await FirebaseFirestore.instance
           .collection("chat_rooms")
           .doc(chatRoomID)
           .collection("messages")
           .doc(messageId)
           .update({
         "isViewed": true,
         "viewedAt": FieldValue.serverTimestamp(),
       });

       debugPrint(" Image marked as viewed");
     } catch (e) {
       debugPrint(" Error marking image as viewed: $e");
     }
   }
   Future<void> deleteViewOnceMessage({
     required String senderId,
     required String receiverId,
     required String messageId,
   }) async {
     List<String> ids = [senderId, receiverId];
     ids.sort();
     String chatRoomID = ids.join("_");

     try {
       final docRef = FirebaseFirestore.instance
           .collection("chat_rooms")
           .doc(chatRoomID)
           .collection("messages")
           .doc(messageId);

       final snap = await docRef.get();
       if (!snap.exists) return;

       final data = snap.data() as Map<String, dynamic>;
       final isViewOnce = data['isViewOnce'] ?? false;
       final isViewed = data['isViewed'] ?? false;
       if (isViewOnce == true && isViewed == true) {
         await docRef.delete();
         debugPrint(" View-once message deleted");
       }
     } catch (e) {
       debugPrint(" Error deleting view-once message: $e");
     }
   }

   Future<void> sendMessage(
       String receiverId,
       String receiverName,
       String message,
       String? image,
       String? file,
       Messages? replyTo,
       {bool isViewOnce = false}
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
       isRead: false,
       isReply: replyTo != null,
       replyTo: replyTo,
       isReacted: false,
       reactBy: null,
       isViewOnce: isViewOnce
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
       "isReacted": false,
       "reactBy": null,
       "isScheduled": false,
       "scheduledTime": time,
       "isViewOnce": isViewOnce,
       "isViewed": false,
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
       "lastMessageType": image != null
           ? "image"
           : file != null
           ? "file"
           : "text",
     }, SetOptions(merge: true));

     final receiverDoc = await FirebaseFirestore.instance
         .collection('users')
         .doc(receiverId)
         .get();

     final receiverToken = receiverDoc.data()?['fcmToken'];

     if (receiverToken == null) {
       print('❌ No FCM token found for receiver: $receiverId');
       return;
     }

     final previewText = message.isNotEmpty
         ? message
         : image != null
         ? "📷 Sent an image"
         : file != null
         ? "📎 Sent a file"
         : auth.currentUser!.displayName!.isEmpty ? "new Message" : "${name} sent a message";

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
   Future<void> addReaction(
       String? senderId,
       String? receiverId,
       String? messageId,
       String? emoji,
       String? senderName,
       String? currentUserName,  //this user reacted
       ) async {
     List<String> ids = [senderId!, receiverId!];
     ids.sort();
     String chatRoomID = ids.join("_");
     try {
       await FirebaseFirestore.instance
           .collection("chat_rooms")
           .doc(chatRoomID)
           .collection("messages")
           .doc(messageId)
           .update({
         "isReacted": true,
         "reactBy": currentUserName,
         "reactionEmoji": emoji,
       });
     } catch (e) {
       debugPrint("❌ Error adding reaction: $e");
     }
   }
   Future<void> removeReactionFromMessage({
      String? senderId,
      String?  receiverId,
      String?  messageId,
   }) async {
     List<String> ids = [senderId!, receiverId!];
     ids.sort();
     String chatRoomID = ids.join("_");

     try {
       await FirebaseFirestore.instance
           .collection("chat_rooms")
           .doc(chatRoomID)
           .collection("messages")
           .doc(messageId)
           .update({
         "isReacted": false,
         "reactBy": null,
         "reactionEmoji": null,
       });
     } catch (e) {
       debugPrint("❌ Error removing reaction: $e");
     }
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
     return users.collection("chat_rooms").doc(chatRoomID).collection("messages").
     orderBy("timestamp", descending: false).snapshots();
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
       final docRef = users.collection("users").doc(uid);
       final snapshot = await docRef.get();
       final currentUser = UserModel.fromDocument(snapshot);
       final updatedUser = currentUser.copyWith(bio: newBio);
       await docRef.update({
         "bio": updatedUser.bio,
       });
     }
   }
   Future<void> reportIssue(String email, String issue) async {
     final user = auth.currentUser;
     try{
       await users.collection("Issues").add({
         'email': email,
         'issue': issue,
         'name': user?.displayName ?? '',
         "reportedAt": FieldValue.serverTimestamp()
       });
     } catch (e) {
       debugPrint("Error during sign-up: $e");
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
   Future<void> onlineStatues(bool isOnline) async {
     final u = FirebaseAuth.instance.currentUser;
     if (u == null) return;

     final ref = FirebaseFirestore.instance.collection('users').doc(u.uid);

     if (isOnline) {
       await ref.set({
         'isOnline': true,
         'lastSeen': FieldValue.serverTimestamp(), // optional, updates anyway
       }, SetOptions(merge: true));
     } else {
       await ref.set({
         'isOnline': false,
         'lastSeen': FieldValue.serverTimestamp(),
       }, SetOptions(merge: true));
     }
   }

   Future<void> updateUserTypingStatus({required bool isTyping, String? typingToUserId,}) async {
     final user = FirebaseAuth.instance.currentUser;
     if (user == null) return;

     try {
       await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
         'isTypingTo': isTyping ? typingToUserId : null,
         'typingTimestamp': FieldValue.serverTimestamp(),
       }, SetOptions(merge: true));
     } catch (e) {
       debugPrint("Error updating typing status: $e");
     }
   }
   Stream<DocumentSnapshot<Map<String, dynamic>>> presenceStream(String userId) {
     return FirebaseFirestore.instance.collection('users').doc(userId).snapshots();
   }
   Future<void> updateOnlineStatus(bool isOnline) async {
     await onlineStatues(true);
   }
   Future<void> updateUserOnlineStatus(bool isOnline) async{
     if(user!.uid.isEmpty) return;
     try{
       await FirebaseFirestore.instance.collection("users").doc(user!.uid).update(
         {
           "isOnline": isOnline,
           "lastSeen": FieldValue.serverTimestamp(),
         }
       );
     } catch(e){

     }
   }
   Future<void> readMsg(String? receiverId) async {
     final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

     if (receiverId == null) return;
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
   Future<void> markRead(String receiverId) async  {
     final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
     List<String> ids = [currentUserId, receiverId];
     ids.sort();
     String chatRoomID = ids.join("_");
     final messagesRef = FirebaseFirestore.instance
         .collection("chat_rooms")
         .doc(chatRoomID)
         .collection("messages");
     final messageRead = await messagesRef.where("receiverId", isEqualTo: currentUserId)
         .where("isRead", isEqualTo: false).orderBy("timestamp", descending: true).limit(1).get();
     for (var doc in messageRead.docs) {
       await doc.reference.update({
         "isRead": true
       });
     }
   }
   Stream<QuerySnapshot>isRead(String chatRoomId, String currentUserId) {
     return FirebaseFirestore.instance
         .collection("chat_rooms")
         .doc(chatRoomId)
         .collection("messages")
         .where("receiverId", isEqualTo: currentUserId)
         .where("isRead", isEqualTo: false)
         .snapshots();
   }
   Stream<int> getTotalUnreadCount(String userId) {
     return FirebaseFirestore.instance
         .collectionGroup("messages")
         .where("receiverId", isEqualTo: userId)
         .where("isRead", isEqualTo: false)
         .snapshots()
         .map((snapshot) => snapshot.docs.length);
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
   Future addToFavourite(String name, {String? image, String? email}) async {
     String email = auth.currentUser!.email!;
     await FirebaseFirestore.instance.collection("Favourites").doc(email).collection("myFavourites").add(
       {
         "name":name,
         "image": image,
         "email": email
       }
     );
   }
   Future MuteChat(String chatRoomId, String userId) async {
     await FirebaseFirestore.instance.collection("mutedChats").doc(userId)
         .set({chatRoomId: true}, SetOptions(merge: true));
   }
   Future unMute(String chatRoomId, String userId) async {
     await FirebaseFirestore.instance.collection("mutedChats").doc(userId)
         .update({chatRoomId: FieldValue.delete()});
   }
   Stream<bool> isChatMutedStream(String chatRoomId, String userId) {
     return FirebaseFirestore.instance
         .collection('mutedChats')
         .doc(userId)
         .snapshots()
         .map((doc) => doc.exists && (doc.data()?[chatRoomId] == true));
   }

   Future removeFavourite(String name) async {
     String email = auth.currentUser!.email!;
    final favourite = await FirebaseFirestore.instance.collection("Favourites").doc(email)
         .collection("myFavourites").where("name", isEqualTo: name).get();
     for(var doc in favourite.docs) {
       await doc.reference.delete();
     }
   }

   Future<bool> isFavourite(String? name) async {
     String email = auth.currentUser!.email!;
     final isFavourite = await FirebaseFirestore.instance
         .collection("Favourites")
         .doc(email)
         .collection("myFavourites")
         .where('name', isEqualTo: name)
         .get();

     return isFavourite.docs.isNotEmpty;
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
         .where("participants", arrayContains: currentUser.uid)
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
// Add this to your FirebaseService class

   Future<void> scheduleMessage({
     required String receiverId,
     required String receiverName,
     required String message,
     required DateTime scheduledTime,
     String? image,
     String? file,
     Messages? replyTo,
   }) async {
     try {
       final String currentUser = auth.currentUser!.uid;
       final String email = auth.currentUser!.email!;
       final String name = auth.currentUser!.displayName ?? "Unknown";
       final Timestamp scheduledTimestamp = Timestamp.fromDate(scheduledTime);

       // Create scheduled message
       Messages scheduledMessage = Messages(
         image: image ?? "",
         file: file ?? "",
         time: scheduledTimestamp,
         text: message,
         senderId: currentUser,
         receiverId: receiverId,
         senderEmail: email,
         receiverEmail: receiverName,
         senderName: name,
         isEdited: false,
         isStarred: false,
         isRead: false,
         isReply: replyTo != null,
         replyTo: replyTo,
         isReacted: false,
         reactBy: null,
       );

       List<String> ids = [currentUser, receiverId];
       ids.sort();
       String chatRoomID = ids.join("_");

       // Add message with scheduled status
       final docRef = await users
           .collection("chat_rooms")
           .doc(chatRoomID)
           .collection("messages")
           .add({
         ...scheduledMessage.toMap(),
         "timestamp": scheduledTimestamp,
         "isScheduled": true,
         "scheduledTime": scheduledTimestamp,
         "isReacted": false,
         "reactBy": null,
       });

       await docRef.update({"messageId": docRef.id});

       myToast("Message scheduled for ${scheduledTime.toString()}");
     } catch (e) {
       debugPrint("Error scheduling message: $e");
       myToast("Failed to schedule message");
     }
   }

   /// Fetch and send all due scheduled messages
   Future<void> processDueScheduledMessages() async {
     try {
       final now = Timestamp.now();

       // Get all scheduled messages across all chat rooms
       final chatRooms = await users
           .collection("chat_rooms")
           .get();

       for (var chatRoom in chatRooms.docs) {
         final dueMessages = await chatRoom.reference
             .collection("messages")
             .where("isScheduled", isEqualTo: true)
             .where("scheduledTime", isLessThanOrEqualTo: now)
             .get();

         for (var msgDoc in dueMessages.docs) {
           final msgData = msgDoc.data();

           // Send push notification
           final receiverDoc = await FirebaseFirestore.instance
               .collection('users')
               .doc(msgData['receiverId'])
               .get();

           final receiverToken = receiverDoc.data()?['fcmToken'];

           if (receiverToken != null) {
             final previewText = msgData['message'].isNotEmpty
                 ? msgData['message']
                 : msgData['image'] != null && msgData['image'].isNotEmpty
                 ? "📷 Sent an image"
                 : msgData['file'] != null && msgData['file'].isNotEmpty
                 ? "📎 Sent a file"
                 : "New message";

             await sendPushNotificationViaFunction(
               token: receiverToken,
               title: "${msgData['senderName']} sent a scheduled message",
               body: previewText,
               receiverId: msgData['receiverId'],
               receiverName: msgData['receiverEmail'],
               image: msgData['image'],
               type: "chat",
             );
           }

           // Mark as sent (no longer scheduled)
           await msgDoc.reference.update({
             "isScheduled": false,
           });
         }
       }
     } catch (e) {
       debugPrint("Error processing scheduled messages: $e");
     }
   }

   /// Get scheduled messages for a specific chat
   Stream<QuerySnapshot> getScheduledMessages(String userID, String otherUser) {
     List<String> ids = [userID, otherUser];
     ids.sort();
     String chatRoomID = ids.join("_");

     return users
         .collection("chat_rooms")
         .doc(chatRoomID)
         .collection("messages")
         .where("isScheduled", isEqualTo: true)
         .orderBy("scheduledTime", descending: false)
         .snapshots();
   }

   /// Get all user's scheduled messages
   Stream<QuerySnapshot> getAllScheduledMessages() {
     final currentUser = auth.currentUser;
     if (currentUser == null) return const Stream.empty();
     return users
         .collectionGroup("messages")
         .where("senderId", isEqualTo: currentUser.uid)
         .where("isScheduled", isEqualTo: true)
         .orderBy("scheduledTime", descending: false)
         .snapshots();
   }

 }