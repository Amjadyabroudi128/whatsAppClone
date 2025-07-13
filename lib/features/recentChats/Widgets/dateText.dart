import 'package:flutter/material.dart';

class dateText extends StatelessWidget {
  const dateText({
    super.key,
    required this.dateTime,
  });

  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    return Text(
      "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}",
      style: const TextStyle(fontSize: 12),
    );
  }
}
