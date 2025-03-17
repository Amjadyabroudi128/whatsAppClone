import 'package:flutter/material.dart';
import 'package:whatsappclone/core/MyColors.dart';

import '../../../core/icons.dart';

class nameCard extends StatelessWidget {
  const nameCard({
    super.key,
    required this.userName,
  });

  final dynamic userName;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: myColors.CardColor,
      child: ListTile(
        title: Text(userName),
        leading: icons.person,
      ),
    );
  }
}
