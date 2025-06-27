import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/TextButton.dart';
import 'package:whatsappclone/components/TextField.dart';
import 'package:whatsappclone/components/flutterToast.dart';
import 'package:whatsappclone/features/chatScreen/chatScreen.dart';

import '../../../Firebase/FirebaseAuth.dart';
import '../../../core/TextStyles.dart';
import '../../../core/icons.dart';
import '../../../messageClass/messageClass.dart';
import 'dialogs/editDialog.dart';

PopupMenuItem<String> editMessage(BuildContext context, Messages msg, FirebaseService service, Testname? widget, User? user) {
  return PopupMenuItem(
      value: 'edit',
      child: kTextButton(
        onPressed: () {
          Navigator.pop(context);
          TextEditingController _controller = TextEditingController(text: msg.text);
          showDialog(
            context: context,
            builder: (context) => editDialog(controller: _controller, msg: msg, service: service,Test: widget, user: user,),
          );
        },
        child: Row(
          children: [
            Text("Edit",style: Textstyles.editText,),
            Spacer(),
            icons.edit,
          ],
        ),
      )
  );
}

