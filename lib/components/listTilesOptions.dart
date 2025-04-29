import 'package:flutter/material.dart';

import 'ListTiles.dart';

Widget Options({
  required BuildContext context, Icon? leading, Icon? trailing, Widget? label, VoidCallback? onTap,}) {
  return kListTile(
    onTap: onTap,
    leading: leading,
    trailing: trailing,
    title: label,
  );
}
