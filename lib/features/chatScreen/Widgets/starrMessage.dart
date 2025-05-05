import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/Firebase/FirebaseAuth.dart';
import 'package:whatsappclone/messageClass/messageClass.dart';

import '../../../components/TextButton.dart';
import '../../../components/TextStyles.dart';
import '../../../components/flutterToast.dart';
import '../../../core/icons.dart';

PopupMenuItem<String> starMessage(BuildContext context, Messages msg, User? user) {
  FirebaseService service = FirebaseService();
  return PopupMenuItem(
    value: "Star",
    child: kTextButton(
      child: Row(
        children: [
          Text("Star",style: Textstyles.copyMessage,),
          Spacer(),
          icons.star,
        ],
      ),
      onPressed: (){
        service.addToStar(msg.text);
        myToast("Message Starred");
        Navigator.of(context).pop();
      },
    ),
  );
}
