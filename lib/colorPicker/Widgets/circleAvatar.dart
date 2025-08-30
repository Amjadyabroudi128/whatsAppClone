
import 'package:flutter/material.dart';
class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    required this.color,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(radius: 30, backgroundColor: color);
  }
}
