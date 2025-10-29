import 'package:flutter/material.dart';

import '../../../Firebase/FirebaseAuth.dart';
import '../../../components/TextButton.dart';
import '../../../core/TextStyles.dart';

class deleteAlert extends StatelessWidget {
  const deleteAlert({
    super.key,
    required this.receiverName,
    required this.context,
    required this.service,
    required this.chatRoomId,

  });

  final dynamic receiverName;
  final BuildContext context;
  final FirebaseService service;
  final String chatRoomId;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("You are about to delete messages with $receiverName"),
      content: const Text("Are you sure ? "),
      actions: [
        kTextButton(
          onPressed: (){
            Navigator.of(context).pop();
            FocusScope.of(Navigator.of(context).context).unfocus();
          },
          child: const Text("Cancel"),
        ),
        kTextButton(
          onPressed: () async {
            await service.deleteRecentChat(chatRoomId, context);
          },
          child: Text("Delete", style: Textstyles.deleteStyle,),
        ),
      ],
    );
  }
}
