

 import 'package:flutter/material.dart';
import 'package:whatsappclone/components/TextStyles.dart';
import 'package:whatsappclone/core/MyColors.dart';

 class myTheme {
   static OutlineInputBorder fieldBorder = OutlineInputBorder(borderRadius: BorderRadius.circular(10),
     borderSide: BorderSide()
   );
   static OutlinedBorder circular = RoundedRectangleBorder(
     borderRadius: BorderRadius.circular(10)
   );
   static BorderRadiusGeometry CircularContainer = BorderRadius.circular(10);
   static ShapeBorder cardShape = RoundedRectangleBorder(
     borderRadius: BorderRadius.circular(10.0),
   );
  static final ThemeData appTheme = ThemeData().copyWith(
    appBarTheme: AppBarTheme(
      centerTitle: true,
      iconTheme: IconThemeData(
          color: Colors.black
      )
    ),
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
      backgroundColor: myColors.FAB,
      foregroundColor: Colors.white60,
      iconSize: 32,
      elevation: 0
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: Textstyles.haveAccount,
        foregroundColor: myColors.textBtn,
      ),
    ),
    dividerTheme: DividerThemeData(
      color: Colors.grey[400],
      indent: 30
    ),
    cardTheme: CardTheme(
      shape: cardShape,
      color: Colors.blueGrey,
    ),
   );

  static final ThemeData darkTheme = ThemeData(
      cardTheme: CardTheme(
        shape: cardShape,
        color: Colors.grey[700],
      ),
      appBarTheme: AppBarTheme(
        color: myColors.darkCard,
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            foregroundColor: Colors.white
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
    listTileTheme: ListTileThemeData(
      textColor: Colors.white
    ),

    scaffoldBackgroundColor: myColors.darkCard,
  );
 }