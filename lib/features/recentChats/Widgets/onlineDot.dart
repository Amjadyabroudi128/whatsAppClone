import 'package:flutter/material.dart';

import '../../../core/MyColors.dart';

Widget presenceDot(bool isOnline) {
  return Positioned(
    right: 2,
    bottom: 2,
    child: Container(
      width: 13,
      height: 13,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isOnline ? MyColors.online : MyColors.menuColor,
        border: Border.all(color: Colors.white, width: 2),
      ),
    ),
  );
}