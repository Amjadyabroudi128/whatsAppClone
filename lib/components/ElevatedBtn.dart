import 'package:flutter/material.dart';

class kElevatedBtn extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? child;
  final WidgetStatePropertyAll<Color>? color;
  const kElevatedBtn({super.key, this.onPressed, this.child, this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: color
      ),
      child: child,
    );
  }
}
