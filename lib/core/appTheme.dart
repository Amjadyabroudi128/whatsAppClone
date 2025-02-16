

 import 'package:flutter/material.dart';

 class myTheme {
  static final ThemeData appTheme = ThemeData().copyWith(
       elevatedButtonTheme: ElevatedButtonThemeData(
         style: ElevatedButton.styleFrom(
             backgroundColor: Colors.green,
             foregroundColor: Colors.white,
             textStyle: TextStyle(fontSize: 18)
         ),
       ),
   );
 }