

 import 'package:flutter/material.dart';
import 'package:whatsappclone/core/ColorHelper.dart';

 class myTheme {
   static OutlinedBorder circular = RoundedRectangleBorder(
     borderRadius: BorderRadius.circular(10)
   );
  static final ThemeData appTheme = ThemeData().copyWith(
       elevatedButtonTheme: ElevatedButtonThemeData(
         style: ElevatedButton.styleFrom(
             backgroundColor: ColorHelper.TC,
             foregroundColor: Colors.white,
             textStyle: TextStyle(fontSize: 18),
           shape: circular
         ),
       ),
   );
 }