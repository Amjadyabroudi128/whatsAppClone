import 'package:flutter/material.dart';

class kTextField extends StatelessWidget {
  final Widget? label;
  final TextEditingController? myController;
  final Widget? myIcon;
  final bool obsecureText;
  const kTextField({super.key, this.label, this.myController, this.myIcon, this.obsecureText = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: myController,
      obscureText: obsecureText,
      decoration: InputDecoration(
        label: label,
        prefixIcon: myIcon,

      ),
    );
  }
}
