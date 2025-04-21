import 'package:flutter/material.dart';

class kTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final ButtonStyle? style;
  const kTextButton({super.key, required this.onPressed, required this.child, this.style});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: style ,
      onPressed: onPressed,
      child: child,
    );
  }
}
