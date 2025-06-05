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
  final int? maxLines;
  final Color? fillColor;
  final bool? filled;
  final VoidCallback? onTap;
  final ScrollController? scroll;
  final TextStyle? hintStyle;
  const kTextField(
      {super.key, this.label, this.myController,
        this.myIcon, this.obsecureText = false, this.border, this.keyBoard, this.hint,
        this.icon, this.suffix, this.maxLines, this.fillColor, this.filled, this.onTap, this.scroll, this.hintStyle});

  @override
  Widget build(BuildContext context) {
    return TextField(
      scrollController: scroll,
      onTap: onTap,
      controller: myController,
      obscureText: obsecureText,
      keyboardType: keyBoard,
      maxLines: maxLines ?? 1,
      // Default to 1 if not provided
      decoration: InputDecoration(
        fillColor: fillColor,
        filled: filled,
        suffixIcon: icon,
        hintText: hint,
        label: label,
        prefixIcon: myIcon,
        suffix: suffix,
        border: border,
        hintStyle: hintStyle
      ),
    );
  }
}