import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/listTilesOptions.dart';
import 'package:whatsappclone/features/chatScreen/chatScreen.dart';
class listTile extends StatelessWidget {
  const listTile({
    super.key,
    required this.userDoc,
  });

  final QueryDocumentSnapshot<Object?> userDoc;

  @override
  Widget build(BuildContext context) {
    return Options(
      context: context,
      label: Text(userDoc["name"] ?? "Unknown"),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Testname(
              receiverId: userDoc["uid"],
              receiverName: userDoc["name"] ?? "Unknown",
            ),
          ),
        );
      },
    );
  }
}
