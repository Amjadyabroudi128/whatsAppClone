import 'package:flutter/material.dart';
import 'package:whatsappclone/features/chatScreen/Model/MessageModel.dart';

import '../../../Firebase/FirebaseAuth.dart';
import '../../../components/TextButton.dart';
import '../../../core/TextStyles.dart';
import '../../../components/flutterToast.dart';

PopupMenuItem<String> starMessage(Messages msg, FirebaseService service, int index, BuildContext context,) {
  final isStarred = msg.isStarred ?? false;
  return PopupMenuItem(
    value: isStarred ? "Unstar" : "Star",
    child: kTextButton(
      child: Row(
        children: [
          Text(isStarred ? "Unstar" : "Star", style: Textstyles.copyMessage),
          const Spacer(),
          isStarred ? const Icon(Icons.star): const Icon(Icons.star_border)
        ],
      ),
      onPressed: () async {
        FocusScope.of(context).unfocus();
        Navigator.of(context).pop();
        if(isStarred) {
          await service.deleteStar(msg);
          myToast("Message Unstarred");
        } else {
          await service.addToStar(msg);
          myToast("Message starred");
        }
      },
    ),
  );
}
