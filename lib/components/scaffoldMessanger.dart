
 import 'package:flutter/material.dart';

void showSnackbar (BuildContext context , String message, {Duration? duration}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: duration ?? const Duration(seconds: 3),
    )
  );
 }