import 'package:flutter/material.dart';

class kCard extends StatelessWidget {
  final Widget? child;
  final ShapeBorder? shape;
  final Clip? clipBehavior;
  final Color? color;
  final double? elevation;
  const kCard({super.key, this.child, this.shape, this.clipBehavior, this.color, this.elevation});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      color: color,
      shape: shape,
      clipBehavior: clipBehavior,
      child: child,
    );
  }
}
