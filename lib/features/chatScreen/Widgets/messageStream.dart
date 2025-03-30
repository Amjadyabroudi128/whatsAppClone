import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../Firebase/FirebaseAuth.dart';
import '../../../messageClass/messageClass.dart';
import '../chatScreen.dart';
import 'alignMessages.dart';

class MessageStream extends StatelessWidget {
  const MessageStream({
    super.key,
    required this.service,
    required this.user,
    required this.widget,
  });

  final FirebaseService service;
  final User? user;
  final Testname widget;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: service.getMessages(user!.uid, widget.receiverId),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No messages yet"));
        }
        var messages = snapshot.data!.docs.map((doc) => Messages(
          text: doc["message"],
          senderId: doc["senderId"],
          receiverId: doc["receiverId"],
          senderEmail: doc["senderEmail"],
          receiverEmail: doc["receiverEmail"],
        )).toList();

        return messagesAlign(messages: messages, user: user);
      },
    );
  }
}
