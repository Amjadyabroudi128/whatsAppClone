import 'package:flutter/material.dart';

import '../../../Firebase/FirebaseAuth.dart';
import '../../../components/TextButton.dart';
import '../../../components/TextStyles.dart';
import '../../../components/flutterToast.dart';
import '../../../core/icons.dart';
import '../../../messageClass/messageClass.dart';

PopupMenuItem<String> starMessage(Messages msg, FirebaseService service, int index, BuildContext context) {
  return PopupMenuItem(
    value: "Star",
    child: kTextButton(
      child: Row(
        children: [
          Text(msg.isStarred == true ? "Unstar" : "Star", style: Textstyles.copyMessage),
          Spacer(),
          (msg.isStarred == true ? icons.amberStar : icons.star),
        ],
      ),
      onPressed: () async {
        if (msg.isStarred == true) {
          await service.deleteStar(msg);
          myToast("Message unstarred");
        } else {
          await service.addToStar(msg);
          myToast("Message starred");
        }
          msg = Messages(
            text: msg.text,
            senderId: msg.senderId,
            receiverId: msg.receiverId,
            senderEmail: msg.senderEmail,
            receiverEmail: msg.receiverEmail,
            time: msg.time,
            messageId: msg.messageId,
            image: msg.image,
            file: msg.file,
            isStarred: !(msg.isStarred ?? false),
          );

        Navigator.pop(context);
      },
    ),
  );
}
