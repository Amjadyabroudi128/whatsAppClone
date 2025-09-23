import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/TextButton.dart';

import 'package:whatsappclone/features/chatScreen/Model/MessageModel.dart';
import 'package:whatsappclone/features/chatScreen/chatScreen.dart';

import '../../../Firebase/FirebaseAuth.dart';
import '../../../core/TextStyles.dart';
import '../../../core/icons.dart';
import 'dialogs/editDialog.dart';

PopupMenuItem<String> editMessage(BuildContext context, Messages msg, FirebaseService service, Testname? widget, User? user) {
  return PopupMenuItem(
      value: 'edit',
      child: kTextButton(
        onPressed: () {
          Navigator.pop(context);
          FocusScope.of(Navigator.of(context).context).unfocus();
          TextEditingController controller = TextEditingController(text: msg.text);
          showDialog(
            context: context,
            builder: (context) => editDialog(controller: controller, msg: msg, service: service,Test: widget, user: user,),
          );
        },
        child: Row(
          children: [
            Text("Edit",style: Textstyles.editText,),
            const Spacer(),
            icons.edit,
          ],
        ),
      )
  );
}

