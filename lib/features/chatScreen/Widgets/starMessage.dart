import 'package:flutter/material.dart';

import '../../../Firebase/FirebaseAuth.dart';
import '../../../components/TextButton.dart';
import '../../../core/TextStyles.dart';
import '../../../components/flutterToast.dart';
import '../../../core/icons.dart';
import '../../../messageClass/messageClass.dart';

PopupMenuItem<String> starMessage(Messages msg, FirebaseService service, int index, BuildContext context,) {
  return PopupMenuItem(
    value: "Star",
    child: kTextButton(
      child: Row(
        children: [
          Text("Star", style: Textstyles.copyMessage),
          Spacer(),
          icons.star,
        ],
      ),
      onPressed: () async {
        FocusScope.of(context).unfocus();
        Navigator.of(context).pop();
        await service.addToStar(msg);
        FocusScope.of(context).unfocus();
        myToast("Message starred");
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
            isStarred: msg.isStarred
          );
      },
    ),
  );
}
