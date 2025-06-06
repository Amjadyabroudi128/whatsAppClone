import 'package:flutter/material.dart';

import '../core/icons.dart';

class kIconButton extends StatelessWidget {
  final Widget? myIcon;
  final VoidCallback? onPressed;
  final double? iconSize;
  final Color? color;
  const kIconButton({super.key, this.myIcon, this.onPressed, this.iconSize, this.color});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed:  onPressed,
      icon: myIcon ?? icons.arrow,
      iconSize: iconSize ,
      color: color,
    );
  }
}
