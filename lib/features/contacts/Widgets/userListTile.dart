import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../chatScreen/chatScreen.dart';

class listTile extends StatelessWidget {
  const listTile({
    super.key,
    required this.userDoc,
  });

  final QueryDocumentSnapshot<Object?> userDoc;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(userDoc["name"] ?? "Unknown Email"),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Testname(username: userDoc["name"],),
          ),
        );
      },
    );
  }
}
