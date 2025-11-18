import 'package:flutter/material.dart';

class userNamecircle extends StatelessWidget {
  const userNamecircle({
    super.key,
    required this.otherUserName,
  });

  final String? otherUserName;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      child: Text(otherUserName![0]),
    );
  }
}
