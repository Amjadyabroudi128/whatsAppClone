
import 'package:flutter/material.dart';

import '../../../components/TextButton.dart';
import '../../../core/TextStyles.dart';
import '../../../core/icons.dart';
import '../../../messageClass/messageClass.dart';

PopupMenuItem<String> selectMessage(BuildContext context, Messages msg, bool isEditing,
    VoidCallback? onToggleEdit, Set<String> selectedMessages, VoidCallback onUpdateState) {
  return PopupMenuItem(
      value: "select",
      child:kTextButton(
        child: Row(
          children: [
            Text("Select",style: Textstyles.copyMessage,),
            Spacer(),
            icons.selectIcon
          ],
        ),
        onPressed: () {
          Navigator.pop(context);
          onUpdateState();
        },
      )
  );
}
