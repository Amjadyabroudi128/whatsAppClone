import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whatsappclone/core/TextStyles.dart';
import 'package:whatsappclone/components/flutterToast.dart';

import '../../../components/TextButton.dart';
import '../../../core/icons.dart';
import '../Model/MessageModel.dart';

PopupMenuItem<String> copyMessage(Messages msg, BuildContext context) {
  return PopupMenuItem(
      value: 'Copy',
      child: kTextButton(
        onPressed: (){
          FocusScope.of(Navigator.of(context).context).unfocus();
          final value = ClipboardData(text: msg.text);
          Clipboard.setData(value);
          Navigator.pop(context);
          myToast("✅ Message Copied");
          FocusScope.of(Navigator.of(context).context).unfocus();
        },
        child: Row(
          children: [
            Text("Copy",style: Textstyles.copyMessage,),
            Spacer(),
            const Icon(Icons.copy),
          ],
        ),
      )
  );
}