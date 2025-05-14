import 'package:flutter/material.dart';

class noMedia extends StatelessWidget {
  const noMedia({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Tap "+" in a Chat to share photos and videos\nwith this Contact',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 17, color: Colors.grey),
    );
  }
}
