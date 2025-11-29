import 'package:flutter/material.dart';

import '../../../core/MyColors.dart';

Widget presenceDot(bool isOnline) {
  return Positioned(
    right: 2,
    bottom: 2,
    child: Container(
      width: 11,
      height: 11,
      decoration: BoxDecoration(
        shape: .circle,
        color: isOnline ? MyColors.online : MyColors.menuColor,
        border: .all(color: Colors.white, width: 1),
      ),
    ),
  );
}