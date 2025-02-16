
import 'package:flutter/material.dart';

class BoxSpacing extends StatelessWidget {
  final double? myHeight;
  final double? mWidth;
  const BoxSpacing({super.key, this.myHeight, this.mWidth});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:  myHeight,
      width: mWidth,
    );
  }
}
