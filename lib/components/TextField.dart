import 'package:flutter/material.dart';
import 'package:whatsappclone/components/TextStyles.dart';

class kTextField extends StatelessWidget {
  final Widget? label;
  final TextEditingController? myController;
  final Widget? myIcon;
  final bool obsecureText;
  final InputBorder? border;
  final TextInputType? keyBoard;
  final String? hint;
  final Widget? icon;
  final Widget? suffix;
  const kTextField({super.key, this.label, this.myController, this.myIcon, this.obsecureText = false, this.border, this.keyBoard, this.hint, this.icon, this.suffix});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: myController,
      obscureText: obsecureText,
      keyboardType: keyBoard,
      decoration: InputDecoration(
        suffixIcon: icon,
        hintText: hint,
        hintStyle: Textstyles.hintStyle,
        label: label,
        prefixIcon: myIcon,
        suffix: suffix,
        border: border,
      ),
    );
  }
}
