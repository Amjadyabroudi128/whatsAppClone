import 'package:flutter/material.dart';

class image extends StatelessWidget {
  const image({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 90,
      backgroundImage: AssetImage("images/circular_crop.png"),
    );
  }
}