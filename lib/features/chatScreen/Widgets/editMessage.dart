import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/TextButton.dart';
import 'package:whatsappclone/components/TextField.dart';
import 'package:whatsappclone/features/chatScreen/chatScreen.dart';

import '../../../Firebase/FirebaseAuth.dart';
import '../../../core/icons.dart';
import '../../../messageClass/messageClass.dart';

PopupMenuItem<String> editMessage(BuildContext context, Messages msg, FirebaseService service, Testname? widget, User? user) {
  return PopupMenuItem(
      value: 'edit',
      child: kTextButton(
        onPressed: () {
          Navigator.pop(context);
          TextEditingController _controller = TextEditingController(text: msg.text);
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Edit Message"),
              content: kTextField(
                myController: _controller,
                hint: "Edit Your Message",
              ),
              actions: [
                kTextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),
                kTextButton(
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
        child: Row(
          children: [
            Text("Edit",style: TextStyle(color: Colors.black),),
            Spacer(),
            icons.edit,
          ],
        ),
      )
  );
}
