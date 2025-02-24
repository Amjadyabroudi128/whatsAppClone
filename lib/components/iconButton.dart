import 'package:flutter/material.dart';

import 'icons.dart';

class kIconButton extends StatelessWidget {
  final Widget? myIcon;
  final VoidCallback? onPressed;
  const kIconButton({super.key, this.myIcon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed:  onPressed,
      icon: myIcon ?? icons.arrow
    );
  }
}
