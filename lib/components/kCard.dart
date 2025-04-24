import 'package:flutter/material.dart';

class kCard extends StatelessWidget {
  final Widget? child;
  final ShapeBorder? shape;
  final Clip? clipBehaviour;
  const kCard({super.key, this.child, this.shape, this.clipBehaviour});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: child,
      shape: shape,
      clipBehavior: clipBehaviour,
    );
  }
}
