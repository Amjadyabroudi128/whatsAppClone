import 'package:flutter/material.dart';

import 'ListTiles.dart';

Widget Options({
  required BuildContext context, Widget? leading, Icon? trailing, Widget? label, VoidCallback? onTap,}) {
  return kListTile(
    onTap: onTap,
    leading: leading,
    trailing: trailing,
    title: label,
  );
}
