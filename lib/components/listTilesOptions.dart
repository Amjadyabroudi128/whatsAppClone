import 'package:flutter/material.dart';

import 'ListTiles.dart';

Widget Options({
  required BuildContext context, Widget? leading, Widget? trailing, Widget? label, VoidCallback? onTap, Widget? subtitle}) {
  return kListTile(
    subtitle: subtitle,
    onTap: onTap,
    leading: leading,
    trailing: trailing,
    title: label,
  );
}
