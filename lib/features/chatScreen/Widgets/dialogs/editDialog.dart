import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../Firebase/FirebaseAuth.dart';
import '../../../../components/TextButton.dart';
import '../../../../components/TextField.dart';
import '../../../../components/flutterToast.dart';
import '../../../../messageClass/messageClass.dart';
import '../../chatScreen.dart';

class editDialog extends StatelessWidget {
  const editDialog({
    super.key,
    required TextEditingController controller, required this.msg, required this.service,
    required this.Test, required this.user
  }) : _controller = controller;

  final TextEditingController _controller;
  final Messages msg;
  final FirebaseService service;
  final Testname? Test;
  final User? user;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Edit Message"),
      content: kTextField(
        myController: _controller,
        hint: "Edit Your Message",
      ),
      actions: [
        kTextButton(
          onPressed: () {
            Navigator.pop(context);
            FocusScope.of(Navigator.of(context).context).unfocus();
          },
          child: Text("Cancel"),
        ),
        kTextButton(
          onPressed: () async {
            FocusScope.of(Navigator.of(context).context).unfocus();
            String newText = _controller.text.trim();
            newText.isEmpty
                ? myToast("message can't be empty")
                : newText == msg.text.trim()
                ? myToast("please Edit this message")
                : await service.updateMessage(
              msg.messageId!,
              user!.uid,
              Test!.receiverId,
              newText,
            ).then((_) => Navigator.pop(context));
            FocusScope.of(Navigator.of(context).context).unfocus();

          },
          child: Text("Save"),
        ),
      ],
    );
  }
}
