import 'package:flutter/material.dart';

class kElevatedBtn extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? child;
  const kElevatedBtn({super.key, this.onPressed, this.child});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: child,
    );
  }
}
