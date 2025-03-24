import 'package:flutter/material.dart';

class MyPopUpMenu<T> extends StatelessWidget {
  final PopupMenuItemBuilder<T> itemBuilder;
  final PopupMenuItemSelected<T> onSelected;
  final AnimationStyle? popUpAnimationStyle;
  final Widget? icon;
  final Color? iconColor;
  const MyPopUpMenu({super.key, required this.itemBuilder, required this.onSelected, this.popUpAnimationStyle, this.icon, this.iconColor, });

  @override
  Widget build(BuildContext context) {
    const kDuration = Duration(milliseconds: 400);
    return PopupMenuButton<T>(
      iconColor: iconColor,
      icon: icon,
      itemBuilder: itemBuilder,
      onSelected: onSelected,
      popUpAnimationStyle: AnimationStyle(
          duration: kDuration
      ),
    );
  }
}