import 'package:flutter/material.dart';

class kimageNet extends StatelessWidget {
  final double? height;
  final double? width;
  final BoxFit? fit;
  final String src;
  const kimageNet({super.key, this.height, this.width, this.fit, required this.src});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      src,
      height: 200,
      width: 200,
      fit: BoxFit.cover,
    );
  }
}
