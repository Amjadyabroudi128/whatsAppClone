import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../components/TextButton.dart';
import '../../../core/icons.dart';
import '../../../messageClass/messageClass.dart';

PopupMenuItem<String> copyMessage(Messages msg) {
  return PopupMenuItem(
      value: 'Copy',
      child: kTextButton(
        onPressed: (){
          final value = ClipboardData(text: msg.text);
          Clipboard.setData(value);
          print("copied${msg.text}");
        },
        child: Row(
          children: [
            Text("Copy",style: TextStyle(color: Colors.black),),
            Spacer(),
            icons.copy,
          ],
        ),
      )
  );
}