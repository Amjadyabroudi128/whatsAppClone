import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../Firebase/FirebaseAuth.dart';
import '../../../../components/SizedBox.dart';
import '../../../../components/TextButton.dart';
import '../../../../components/flutterToast.dart';
import '../../../../components/imageNetworkComponent.dart';
import '../../../../core/TextStyles.dart';
import '../../../../messageClass/messageClass.dart';
import '../../chatScreen.dart';

class deleteDialog extends StatelessWidget {
  const deleteDialog({
    super.key,
    required this.msg,
    required this.service,
    this.Test,
    this.user,
  });

  final Messages msg;
  final FirebaseService service;
  final Testname? Test;
  final User? user;

  @override
  Widget build(BuildContext context) {
    // Determine message type and content to display
    String messageType;
    Widget titleWidget;

    if (msg.text.isNotEmpty) {
      messageType = "text";
      titleWidget = Text("You are about to delete \"${msg.text}\"");
    } else if (msg.image != null && msg.image!.isNotEmpty) {
      messageType = "image";
      titleWidget = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("You are about to delete this image"),
          const BoxSpacing(),
          kimageNet(
            src: msg.image!,
          ),
        ],
      );
    } else if (msg.file != null && msg.file!.isNotEmpty) {
      messageType = "file";
      titleWidget = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("You are about to delete this file"),
          const BoxSpacing(),
          kimageNet(
            src: msg.file!,
          ),
        ],
      );
    } else {
      messageType = "unknown";
      titleWidget = const Text("You are about to delete this message");
    }

    return AlertDialog(
      title: titleWidget,
      content: const Text("Are you sure?"),
      actions: [
        kTextButton(
          onPressed: () {
            Navigator.of(context).pop();
            FocusScope.of(Navigator.of(context).context).unfocus();
          },
          child: const Text("Cancel"),
        ),
        kTextButton(
          onPressed: () async {
            FocusScope.of(Navigator.of(context).context).unfocus();
            Navigator.of(context).pop();
            myToast("Message Successfully Deleted");
            FocusScope.of(Navigator.of(context).context).unfocus();
            await service.Deletemessage(
              msg.senderId!,
              msg.receiverId!,
              msg.messageId!,
            );
            await service.deleteStar(msg);

          },
          child: Text("Delete", style: Textstyles.deleteStyle,),
        ),
      ],
    );
  }
}