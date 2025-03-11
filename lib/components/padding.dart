import 'package:flutter/cupertino.dart';

class myPadding extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry padding;
  const myPadding({super.key, required this.child, required this.padding});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding:  padding,
      child: child,
    );
  }
}