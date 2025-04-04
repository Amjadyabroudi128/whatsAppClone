import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../Firebase/FirebaseAuth.dart';
import '../../../messageClass/messageClass.dart';
import '../chatScreen.dart';

class myDialog extends StatelessWidget {
  const myDialog({
    super.key,
    required this.msg,
    required this.service,
    required this.user,
    required this.widget,
  });

  final Messages msg;
  final FirebaseService service;
  final User? user;
  final Testname? widget;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Message Options"),
      content: Text("Do you want to edit or delete this message?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            TextEditingController _controller = TextEditingController(text: msg.text);
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Edit Message"),
                content: TextField(
                  controller: _controller,
                  decoration: InputDecoration(hintText: "Edit your message"),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () async {
                      String newText = _controller.text.trim();
                      if (newText.isNotEmpty) {
                        await service.updateMessage(
                          msg.messageId!,
                          user!.uid,
                          widget!.receiverId,
                          newText,
                        );
                      }
                      Navigator.pop(context); // Close the edit dialog
                    },
                    child: Text("Save"),
                  ),
                ],
              ),
            );
          },
          child: Text("Edit", style: TextStyle(fontSize: 19, color: Colors.grey.shade800),),
        ),
        TextButton(
          onPressed: () async {
            await service.Deletemessage(
              user!.uid,
              widget!.receiverId,
              msg.messageId!,
            );
            Navigator.pop(context); // Close dialog after deleting
          },
          child: Text("Delete", style: TextStyle(fontSize: 18, color: Colors.red),),
        ),
      ],
    );
  }
}
