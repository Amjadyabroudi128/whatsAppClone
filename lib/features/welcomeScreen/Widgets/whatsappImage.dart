import 'package:flutter/material.dart';

class image extends StatelessWidget {
  const image({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: MediaQuery.of(context).size.height * 0.169,
      backgroundImage: AssetImage("images/circular_crop.png"),
    );
  }
}