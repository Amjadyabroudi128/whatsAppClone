
 import 'package:flutter/material.dart';

void showSnackbar (BuildContext context , String message, {Duration? duration}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: duration ?? Duration(seconds: 3),
    )
  );
 }