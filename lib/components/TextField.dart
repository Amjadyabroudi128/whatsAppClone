import 'package:flutter/material.dart';

class kTextField extends StatelessWidget {
  final Widget? label;
  final TextEditingController? myController;
  final Widget? myIcon;
  final bool obsecureText;
  final InputBorder? border;
  final TextInputType? keyBoard;
  final String? hint;
  const kTextField({super.key, this.label, this.myController, this.myIcon, this.obsecureText = false, this.border, this.keyBoard, this.hint});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: myController,
      obscureText: obsecureText,
      keyboardType: keyBoard,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
        label: label,
        prefixIcon: myIcon,
        border: border,
      ),
    );
  }
}
