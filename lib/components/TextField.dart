import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:whatsappclone/core/TextStyles.dart';

class kTextField extends StatelessWidget {
  final Widget? label;
  final TextEditingController? myController;
  final Widget? myIcon;
  final bool obscureText;
  final InputBorder? border;
  final InputBorder? enable;
  final InputBorder? focused;
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
  final TextStyle? style;
  final Color? textColor;
  final String? prefixText;
  final TextStyle? prefixStyle;
  final bool? enabled;
  final TextInputAction? textInputAction;
  const kTextField(
      {super.key, this.label, this.myController,
        this.myIcon,this.obscureText = false,
        this.border, this.keyBoard, this.hint,
        this.icon, this.suffix, this.maxLines, this.fillColor, this.filled, this.onTap, this.scroll, this.hintStyle, this.style, this.enable,
        this.focused, this.textColor, this.prefixText, this.prefixStyle, this.enabled, this.textInputAction});

  @override
  Widget build(BuildContext context) {
    final color = textColor ?? Theme.of(context).textTheme.bodyMedium?.color;
    return TextField(
      scrollController: scroll,
      onTap: onTap,
      controller: myController,
      obscureText: obscureText,
      keyboardType: keyBoard,
      maxLines: maxLines,
      enabled: enabled,
      style: TextStyle(color: color),
      textInputAction: textInputAction,
      decoration: InputDecoration(
        fillColor: fillColor,
        prefixText: prefixText,
        prefixStyle: prefixStyle,
        enabledBorder: enable,
        focusedBorder: focused,
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