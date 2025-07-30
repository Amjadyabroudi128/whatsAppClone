

import 'package:flutter/material.dart';

import 'MyColors.dart';
import 'appTheme.dart';

EdgeInsetsGeometry containerPadding = EdgeInsets.all(10);
EdgeInsetsGeometry containermargin = EdgeInsets.symmetric(vertical: 5, horizontal: 10);
Decoration containerDecoration({Color? color, BorderRadiusGeometry? borderRadius}) {
  return BoxDecoration(
    color: color,
    borderRadius: myTheme.CircularContainer,
  );
}
Decoration readDecoration() {
  return BoxDecoration(
    color: myColors.read,
    borderRadius: BorderRadius.circular(12),
  );
}
// Padding containerPadding() {
//   return EdgeInsets.symmetric(horizontal: 6, vertical: 2),
// }
EdgeInsetsGeometry unreadPadding = EdgeInsets.symmetric(horizontal: 6, vertical: 2);
Decoration replyDecoration({Color? color, BorderRadiusGeometry? borderRadius, BoxBorder? border}) {
  return BoxDecoration(
    color: color,
    borderRadius: borderRadius,
    border: border
  );
}