

 import 'package:flutter/material.dart';
import 'package:whatsappclone/components/TextStyles.dart';
import 'package:whatsappclone/core/MyColors.dart';

 class myTheme {
   static OutlineInputBorder fieldBorder = OutlineInputBorder(
     borderRadius: BorderRadius.circular(8),
     borderSide: BorderSide(width: 1,)
   );
   static OutlinedBorder circular = RoundedRectangleBorder(
     borderRadius: BorderRadius.circular(10)
   );
   static BorderRadiusGeometry CircularContainer = BorderRadius.circular(10);
  static final ThemeData appTheme = ThemeData().copyWith(
       elevatedButtonTheme: ElevatedButtonThemeData(
         style: ElevatedButton.styleFrom(
             backgroundColor: myColors.TC,
             foregroundColor: myColors.FG,
             textStyle: Textstyles.Ebtn,
           shape: circular
         ),
       ),
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: fieldBorder,
      focusedBorder: fieldBorder,
      focusColor: myColors.labelClr,
      labelStyle: Textstyles.label,
      hintStyle: Textstyles.hintStyle,
      floatingLabelStyle: Textstyles.floating
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: myColors.FAB
    ),
   );
 }