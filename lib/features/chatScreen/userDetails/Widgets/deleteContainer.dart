import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/TextStyles.dart';
import 'package:whatsappclone/core/icons.dart';

import '../../../../Firebase/FirebaseAuth.dart';
import '../../../../components/flutterToast.dart';
import '../../../../components/iconButton.dart';
import '../../../../components/kCard.dart';
import '../../../../components/listTilesOptions.dart';
import '../../../../core/MyColors.dart';
import '../../../../messageClass/messageClass.dart';
import '../imageScreen.dart';

class deleteContainer extends StatelessWidget {
  const deleteContainer({
    super.key,
    required this.service,
    required this.user,
    required this.widget,
    required this.msg,
  });

  final FirebaseService service;
  final User? user;
  final Imagescreen widget;
  final Messages msg;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Delete message?",
                style: Textstyles.btmSheet,
              ),
              Spacer(),
              kIconButton(
                myIcon: icons.close,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          kCard(
            color: Colors.grey[350],
            child: Options(
              onTap: () async {
                Navigator.pop(context); // Close bottom sheet
                Navigator.pop(context, 'deleted'); // Pass back a result
                await service.Deletemessage(
                  user!.uid,
                  widget.receiverId!,
                  widget.messageId!,
                );
                myToast("Message Successfully Deleted");
                service.deleteStar(msg);
              },
              label: Text(
                "Delete for Everyone",
                style: TextStyle(color: myColors.redAccent),
              ),
              context: context,
            ),
          ),
        ],
      ),
    );
  }
}
