import 'package:flutter/material.dart';
import 'package:whatsappclone/core/MyColors.dart';
import 'package:whatsappclone/core/TextStyles.dart';

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
        decoration:  BoxDecoration(
          color: MyColors.TC,
          shape: .circle,
        ),
        constraints: const BoxConstraints(minWidth: 23, minHeight: 25),
        child: Text(
          unreadCount.toString(),
          style: Textstyles.unreadCount,
          textAlign: .center,
        ),
      ),
    );
  }
}
