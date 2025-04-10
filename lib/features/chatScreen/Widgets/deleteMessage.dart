import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/Firebase/FirebaseAuth.dart';
import 'package:whatsappclone/components/TextButton.dart';
import 'package:whatsappclone/features/chatScreen/chatScreen.dart';
import 'package:whatsappclone/messageClass/messageClass.dart';

import '../../../components/TextStyles.dart';
import '../../../core/icons.dart';

PopupMenuItem<String> deleteMessage(BuildContext context, Messages msg, Testname? widget, User? user, FirebaseService service) {
  return PopupMenuItem<String>(
      value: 'delete',
      child: kTextButton(
        onPressed: (){
          showDialog(context: context,
            builder: (context) => AlertDialog(
              title: Text("you are about to delete ${msg.text}"),
              content: Text("Are you sure? "),
              actions: [
                kTextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),
                kTextButton(
                  onPressed: () async {
                    await service.Deletemessage(
                      user!.uid,
                      widget!.receiverId,
                      msg.messageId!,
                    );
                    Navigator.pop(context);
                  },
                  child: Text("Delete", style: Textstyles.deleteStyle,),
                ),
              ],
            )
          );
        },
        child: Row(
          children: [
            Text("Delete", style: Textstyles.deletemessage),
            Spacer(),
            icons.deleteIcon,
          ],
        ),
      )
  );
}
