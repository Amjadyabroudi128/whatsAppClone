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
    required this.widget, this.onReply
  });

  final FirebaseService service;
  final User? user;
  final Testname widget;
  final void Function(Messages message)? onReply; // <-- Add this line

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
        var messages = snapshot.data!.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;

          return Messages(
            text: data["message"],
            senderId: data["senderId"],
            receiverId: data["receiverId"],
            senderEmail: data["senderEmail"],
            receiverEmail: data["receiverEmail"],
            time: data["timestamp"],
            image: data.containsKey('image') ? data["image"] : null,
            file: data.containsKey("file") ? data["file"] : null,
            messageId: doc.id,
            isReply: data.containsKey("isReply") ? data["isReply"] : false,
            replyTo: data.containsKey("replyTo") && data["replyTo"] != null
                ? Messages.fromMap(Map<String, dynamic>.from(data["replyTo"]))
                : null,
          );
        }).toList();


        return messagesAlign(messages: messages, user: user, widget: widget, onReply: onReply,);
      },
    );
  }
}
