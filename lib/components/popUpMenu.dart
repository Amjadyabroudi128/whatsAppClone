import 'package:flutter/material.dart';

class MyPopUpMenu extends StatelessWidget {
  final PopupMenuItemBuilder itemBuilder;
  final PopupMenuItemSelected onSelected;
  final Widget? icon;
  final Color? iconColor;
  const MyPopUpMenu({
    super.key,
    required this.itemBuilder,
    required this.onSelected,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: icon ?? Icon(Icons.more_vert, color: iconColor),
      itemBuilder: itemBuilder,
      onSelected: onSelected,
    );
  }
}
