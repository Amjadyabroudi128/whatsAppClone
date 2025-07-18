import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../Firebase/FirebaseAuth.dart';
import '../../../messageClass/messageClass.dart';
import '../chatScreen.dart';
import 'alignMessages.dart';

class MessageStream extends StatefulWidget {
   MessageStream({
    super.key,
    required this.service,
    required this.user,
    required this.widget, this.onReply,  this.controller, this.textColor,
    required this.selectedMessages,
    required this.isEditing,
     this.onToggleEdit, // 👈 ADD THIS

  });

  final FirebaseService service;
  final User? user;
  final Testname widget;
  final TextEditingController? controller;
  final void Function(Messages message)? onReply;
  final Color? textColor;
  final Set<String> selectedMessages;
   final bool isEditing;
   final VoidCallback? onToggleEdit; // 👈 ADD THIS

   @override
  State<MessageStream> createState() => _MessageStreamState();
}

class _MessageStreamState extends State<MessageStream> {


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.service.getMessages(widget.user!.uid, widget.widget.receiverId),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No messages yet", style: TextStyle(color: widget.textColor),));
        }
        var messages = snapshot.data!.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final message = Messages(
            isRead: (data["isRead"] ?? false) as bool,
            text: data["message"],
            senderId: data["senderId"],
            senderName: data["senderName"],
            receiverId: data["receiverId"],
            senderEmail: data["senderEmail"],
            receiverEmail: data["receiverEmail"],
            time: data["timestamp"],
            image: data.containsKey('image') ? data["image"] : null,
            file: data.containsKey("file") ? data["file"] : null,
            messageId: doc.id,
            isEdited: (data["isEdited"] ?? false) as bool,
            isStarred: (data["isStarred"] ?? false) as bool,
            isReply: (data["isReply"] ?? false) as bool,
            replyTo: data.containsKey("replyTo") && data["replyTo"] != null
                ? Messages.fromMap(Map<String, dynamic>.from(data["replyTo"]))
                : null,
          );

          return message;
        }).toList();

        return messagesAlign(messages: messages, user: widget.user,
            widget: widget.widget, onReply: widget.onReply,
            textColor: widget.textColor, isEditing : widget.isEditing, selectedMessages: widget.selectedMessages,
          onToggleEdit: widget.onToggleEdit ?? () {},
        );
      },
    );
  }
}
