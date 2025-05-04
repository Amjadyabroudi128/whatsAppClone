import 'package:flutter/material.dart';

import '../../../components/TextButton.dart';
import '../../../components/TextStyles.dart';
import '../../../components/flutterToast.dart';
import '../../../core/icons.dart';

PopupMenuItem<String> starMessage(BuildContext context) {
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
        myToast("Message Starred");
        Navigator.of(context).pop();
      },
    ),
  );
}
