import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/core/consts.dart';

import '../../../core/MyColors.dart';
import '../../../core/appTheme.dart';
import '../../../messageClass/messageClass.dart';

class messagesAlign extends StatelessWidget {
  const messagesAlign({
    super.key,
    required this.messages,
    required this.user,
  });

  final List<Messages> messages;
  final User? user;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        bool isMe = msg.senderId == user!.uid;
        return Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin:  containermargin,
            padding:  containerPadding,
            decoration: BoxDecoration(
              color: isMe ? myColors.myMessage : myColors.message,
              borderRadius: myTheme.CircularContainer,
            ),
            child: Text(msg.text),
          ),
        );
      },
    );
  }
}
