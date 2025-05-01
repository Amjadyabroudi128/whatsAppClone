import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/Firebase/FirebaseAuth.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/TextButton.dart';
import 'package:whatsappclone/features/chatScreen/chatScreen.dart';
import 'package:whatsappclone/messageClass/messageClass.dart';

import '../../../components/TextStyles.dart';
import '../../../components/flutterToast.dart';
import '../../../components/imageNetworkComponent.dart';
import '../../../core/icons.dart';

PopupMenuItem<String> deleteMessage(BuildContext context, Messages msg, Testname? widget, User? user, FirebaseService service) {
  return PopupMenuItem<String>(
      value: 'delete',
      child: kTextButton(
        onPressed: (){
          Navigator.pop(context);
          showDialog(context: context,
            builder: (context) => AlertDialog(
              title: msg.image != null && msg.image!.isNotEmpty ?
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("You are about to delete"),
                  BoxSpacing(),
                  kimageNet(
                    src: msg.image!,
                  ),
                ],
              ) :Text("You are about to delete ${msg.text}"),
              content: Text("Are you sure? "),
              actions: [
                kTextButton(
                  onPressed: () =>  Navigator.pop(context),
                  child: Text("Cancel"),
                ),
                kTextButton(
                  onPressed: () async {
                    await service.Deletemessage(
                      user!.uid,
                      widget!.receiverId,
                      msg.messageId!,
                    );
                    Navigator.pop(context); // Close dialog after deleting
                    myToast("Message Successfully Deleted");
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
