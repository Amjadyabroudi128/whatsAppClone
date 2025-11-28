

import 'package:flutter/material.dart';

import 'MyColors.dart';
import 'appTheme.dart';

EdgeInsetsGeometry containerPadding = const .all(10);
EdgeInsetsGeometry containermargin = const .symmetric(vertical: 5, horizontal: 10);
Decoration containerDecoration({Color? color, BorderRadiusGeometry? borderRadius}) {
  return BoxDecoration(
    color: color,
    borderRadius: MyTheme.circularContainer,
  );
}
Decoration readDecoration() {
  return BoxDecoration(
    color: MyColors.read,
    borderRadius: .circular(12),
  );
}
// Padding containerPadding() {
//   return EdgeInsets.symmetric(horizontal: 6, vertical: 2),
// }
EdgeInsetsGeometry unreadPadding = const .symmetric(horizontal: 6, vertical: 2);
Decoration replyDecoration({Color? color, BorderRadiusGeometry? borderRadius, BoxBorder? border}) {
  return BoxDecoration(
    color: color,
    borderRadius: borderRadius,
    border: border
  );
}
final OutlineInputBorder messageBorder = OutlineInputBorder(
    borderRadius: .circular(10),
    borderSide: const BorderSide(color: Colors.black),
);