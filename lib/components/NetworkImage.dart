import 'package:flutter/material.dart';

class UserImage extends StatelessWidget {
  const UserImage({
    super.key,
    required this.userImage,
  });

  final dynamic userImage;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: NetworkImage(userImage),
      radius: 20,
    );
  }
}