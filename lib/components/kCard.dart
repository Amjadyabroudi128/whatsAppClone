import 'package:flutter/material.dart';

class kCard extends StatelessWidget {
  final Widget? child;
  final ShapeBorder? shape;
  final Clip? clipBehavior;
  final Color? color;
  const kCard({super.key, this.child, this.shape, this.clipBehavior, this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: child,
      shape: shape,
      clipBehavior: clipBehavior,
    );
  }
}
