

import 'package:flutter/material.dart';

import 'appTheme.dart';

EdgeInsetsGeometry containerPadding = EdgeInsets.all(10);
EdgeInsetsGeometry containermargin = EdgeInsets.symmetric(vertical: 5, horizontal: 10);
Decoration containerDecoration({Color? color, BorderRadiusGeometry? borderRadius}) {
  return BoxDecoration(
    color: color,
    borderRadius: myTheme.CircularContainer,
  );
}
