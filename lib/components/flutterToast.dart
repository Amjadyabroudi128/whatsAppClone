import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void myToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.SNACKBAR,
    backgroundColor: Colors.black54,
    textColor: Colors.white,
    fontSize: 17.0,
  );
}
