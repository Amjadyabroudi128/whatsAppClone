import 'package:flutter/material.dart';

import 'ListTiles.dart';

Options(BuildContext context, Icon icon, Widget label, VoidCallback onTap) {
  return kListTile(
    onTap: onTap,
    leading: icon,
    trailing: icon,
    title: label,
  );
}