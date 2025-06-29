import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../Firebase/FirebaseAuth.dart';
import '../../../../components/SizedBox.dart';
import '../../../../components/TextButton.dart';
import '../../../../components/flutterToast.dart';
import '../../../../components/imageNetworkComponent.dart';
import '../../../../core/TextStyles.dart';
import '../../../../messageClass/messageClass.dart';
import '../../chatScreen.dart';

class deleteDialog extends StatelessWidget {
  const deleteDialog({
    super.key,  required this.msg, required this.service, this.Test, this.user,
  });
  final Messages msg;
  final FirebaseService service;
  final Testname? Test;
  final User? user;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
          onPressed: (){
            Navigator.of(context).pop();
            FocusScope.of(Navigator.of(context).context).unfocus();
          },
          child: Text("Cancel"),
        ),
        kTextButton(
          onPressed: () async {
            Navigator.of(context).pop();
            myToast("Message Successfully Deleted");
            FocusScope.of(Navigator.of(context).context).unfocus();
            await service.Deletemessage(
              msg.senderId!,
              msg.receiverId!,
              msg.messageId!,
            );
            FocusScope.of(Navigator.of(context).context).unfocus();
            await service.deleteStar(msg);
            FocusScope.of(Navigator.of(context).context).unfocus();
            },
          child: Text("Delete", style: Textstyles.deleteStyle,),
        ),
      ],
    );
  }
}
