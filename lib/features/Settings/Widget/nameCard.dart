import 'package:flutter/material.dart';

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
      color: Colors.grey.shade100,
      child: ListTile(
        title: Text(userName),
        leading: icons.person,
      ),
    );
  }
}
