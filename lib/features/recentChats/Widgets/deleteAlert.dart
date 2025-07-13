import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../Firebase/FirebaseAuth.dart';
import '../../../components/TextButton.dart';

class deleteAlert extends StatelessWidget {
  const deleteAlert({
    super.key,
    required this.receiverName,
    required this.context,
    required this.service,
    required this.chat,
  });

  final dynamic receiverName;
  final BuildContext context;
  final FirebaseService service;
  final QueryDocumentSnapshot<Object?> chat;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("You are about to delete messages with ${receiverName}"),
      content: Text("Are you sure ? "),
      actions: [
        kTextButton(
          onPressed: (){
            Navigator.of(context).pop();
            FocusScope.of(Navigator.of(context).context).unfocus();
          },
          child: Text("Cancel"),
        ),
        kTextButton(
          onPressed: () async {
            await service.deleteRecentChat(chat.id, context);
          },
          child: Text("Delete", style: Textstyles.deleteStyle,),
        ),
      ],
    );
  }
}
