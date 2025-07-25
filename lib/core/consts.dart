

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
