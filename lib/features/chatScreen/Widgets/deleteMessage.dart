import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/Firebase/FirebaseAuth.dart';
import 'package:whatsappclone/components/TextButton.dart';
import 'package:whatsappclone/features/chatScreen/Model/MessageModel.dart';
import 'package:whatsappclone/features/chatScreen/chatScreen.dart';
import '../../../core/TextStyles.dart';
import '../../../core/icons.dart';
import 'dialogs/deleteDialog.dart';

PopupMenuItem<String> deleteMessage(BuildContext context, Messages msg, Testname? widget, User? user, FirebaseService service) {
  return PopupMenuItem<String>(
      value: 'delete',
      child: kTextButton(
        onPressed: (){
          Navigator.pop(context);
          showDialog(context: context,
            builder: (context) => deleteDialog(msg: msg, service: service)
          );
        },
        child: Row(
          children: [
            Text("Delete", style: Textstyles.deletemessage),
            const Spacer(),
            icons.deleteIcon,
          ],
        ),
      )
  );
}

