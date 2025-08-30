

import 'package:flutter/material.dart';

import 'MyColors.dart';
import 'appTheme.dart';

EdgeInsetsGeometry containerPadding = const EdgeInsets.all(10);
EdgeInsetsGeometry containermargin = const EdgeInsets.symmetric(vertical: 5, horizontal: 10);
Decoration containerDecoration({Color? color, BorderRadiusGeometry? borderRadius}) {
  return BoxDecoration(
    color: color,
    borderRadius: MyTheme.circularContainer,
  );
}
Decoration readDecoration() {
  return BoxDecoration(
    color: MyColors.read,
    borderRadius: BorderRadius.circular(12),
  );
}
// Padding containerPadding() {
//   return EdgeInsets.symmetric(horizontal: 6, vertical: 2),
// }
EdgeInsetsGeometry unreadPadding = const EdgeInsets.symmetric(horizontal: 6, vertical: 2);
Decoration replyDecoration({Color? color, BorderRadiusGeometry? borderRadius, BoxBorder? border}) {
  return BoxDecoration(
    color: color,
    borderRadius: borderRadius,
    border: border
  );
}