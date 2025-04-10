import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whatsappclone/components/TextStyles.dart';
import 'package:whatsappclone/components/flutterToast.dart';

import '../../../components/TextButton.dart';
import '../../../core/icons.dart';
import '../../../messageClass/messageClass.dart';

PopupMenuItem<String> copyMessage(Messages msg, BuildContext context) {
  return PopupMenuItem(
      value: 'Copy',
      child: kTextButton(
        onPressed: (){
          final value = ClipboardData(text: msg.text);
          Clipboard.setData(value);
          Navigator.pop(context);
          myToast("✅ Message Copied");
        },
        child: Row(
          children: [
            Text("Copy",style: Textstyles.copyMessage,),
            Spacer(),
            icons.copy,
          ],
        ),
      )
  );
}