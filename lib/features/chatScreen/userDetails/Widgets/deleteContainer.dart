import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/core/TextStyles.dart';
import 'package:whatsappclone/core/icons.dart';
import '../../../../Firebase/FirebaseAuth.dart';
import '../../../../components/flutterToast.dart';
import '../../../../components/iconButton.dart';
import '../../../../components/kCard.dart';
import '../../../../components/listTilesOptions.dart';
import '../../Model/MessageModel.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Delete Image?",
                style: Textstyles.btmSheet,
              ),
              const Spacer(),
              kIconButton(
                myIcon: icons.close,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          const BoxSpacing(myHeight: 13,),
          kCard(
            child: Options(
              onTap: () async {
                FocusScope.of(context).unfocus();
                Navigator.pop(context); // Close bottom sheet
                Navigator.pop(context, 'deleted'); // Pass back a result
                service.Deletemessage(msg.senderId!, msg.receiverId!, msg.messageId!,);
                myToast("Message Successfully Deleted");
                await service.deleteStar(msg);
              },
              label: Text(
                "Delete for Everyone",
                style: Textstyles.deletemessage
              ),
              context: context,
            ),
          ),
        ],
      ),
    );
  }
}
