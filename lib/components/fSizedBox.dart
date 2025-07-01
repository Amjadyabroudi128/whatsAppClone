import 'package:flutter/material.dart';

class fSizedBox extends StatelessWidget {
  final double? heightFactor;
  final Widget? child;
  const fSizedBox({super.key, this.heightFactor, this.child});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: heightFactor,
      child: child,
    );
  }
}
