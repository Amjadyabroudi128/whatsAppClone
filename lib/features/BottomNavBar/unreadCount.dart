import 'package:flutter/material.dart';

class unread extends StatelessWidget {
  const unread({
    super.key,
    required this.unreadCount,
  });

  final int unreadCount;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: -12,
      top: -15,
      child: Container(
        padding: const .all(4),
        decoration: const BoxDecoration(
          color: Colors.green,
          shape: .circle,
        ),
        constraints: const BoxConstraints(minWidth: 23, minHeight: 25),
        child: Text(
          unreadCount.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          textAlign: .center,
        ),
      ),
    );
  }
}
