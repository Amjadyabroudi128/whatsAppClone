import 'package:flutter/material.dart';

class kTextField extends StatelessWidget {
  final Widget? label;
  final TextEditingController? myController;
  final Widget? myIcon;
  const kTextField({super.key, this.label, this.myController, this.myIcon});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: myController,
      decoration: InputDecoration(
        label: label,
        prefixIcon: myIcon,
      ),
    );
  }
}
