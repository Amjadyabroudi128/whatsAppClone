
 import 'package:flutter/material.dart';

void showSnackbar (BuildContext context , Widget message, {Duration? duration}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: message,
      duration: duration ?? Duration(seconds: 3),
    )
  );
 }