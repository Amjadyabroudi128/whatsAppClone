

 import 'package:flutter/material.dart';
import 'package:whatsappclone/components/TextStyles.dart';
import 'package:whatsappclone/core/MyColors.dart';

 class myTheme {
   static OutlineInputBorder fieldBorder = OutlineInputBorder(borderRadius: BorderRadius.circular(10),
     borderSide: BorderSide()
   );
   static OutlineInputBorder darkBoder = OutlineInputBorder(borderRadius: BorderRadius.circular(10),
       borderSide: BorderSide(
           color: Colors.white
       )
   );
   static OutlinedBorder circular = RoundedRectangleBorder(
     borderRadius: BorderRadius.circular(10)
   );
   static BorderRadiusGeometry CircularContainer = BorderRadius.circular(10);
   static ShapeBorder cardShape = RoundedRectangleBorder(
     borderRadius: BorderRadius.circular(10.0),
   );
  static final ThemeData appTheme = ThemeData().copyWith(
    scaffoldBackgroundColor: Colors.white,
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
        foregroundColor: Colors.black,
      ),
    ),
    dividerTheme: DividerThemeData(
      color: Colors.grey[400],
      indent: 30
    ),
    cardTheme: CardTheme(
      shape: cardShape,
      color: Colors.white60,
    ),
    bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Colors.black),
      displayMedium: TextStyle(color: Colors.black),
      displaySmall: TextStyle(color: Colors.black),
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium:TextStyle(color: Colors.black),
      bodySmall: TextStyle(color: Colors.black),
      headlineLarge: TextStyle(color: Colors.black),
      headlineMedium: TextStyle(color: Colors.black),
      headlineSmall: TextStyle(color: Colors.black),
      titleLarge: TextStyle(color: Colors.black),
      titleMedium:TextStyle(color: Colors.black) ,
      titleSmall: TextStyle(color: Colors.black),
      labelLarge: TextStyle(color: Colors.black),
      labelMedium:TextStyle(color: Colors.black) ,
      labelSmall: TextStyle(color: Colors.black),
    ),
   );
  static final ThemeData darkTheme = ThemeData().copyWith(
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
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          backgroundColor: myColors.TC,
          foregroundColor: myColors.FG,
          textStyle: Textstyles.Ebtn,
          shape: circular
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: Textstyles.haveAccount,
        foregroundColor: Colors.white,
      )
    ),
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
              color: Colors.white
          )
      ),
      focusedBorder: darkBoder,
      errorBorder: darkBoder,
      // enabledBorder: fieldBorder,
      // focusedBorder: fieldBorder,
      focusColor: Colors.white,
      labelStyle: TextStyle(color: Colors.white),
      hintStyle: TextStyle(color: Colors.white),
      floatingLabelStyle: TextStyle(color: Colors.white),
    ),
    listTileTheme: ListTileThemeData(
        textColor: Colors.white
    ),
    iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: Colors.white,
        )
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.black,
      shape:  RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: Colors.black,
    ),
    iconTheme: IconThemeData(
      color: Colors.black
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Colors.white),
      displayMedium: TextStyle(color: Colors.white),
      displaySmall: TextStyle(color: Colors.white),
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium:TextStyle(color: Colors.white),
      bodySmall: TextStyle(color: Colors.white),
      headlineLarge: TextStyle(color: Colors.white),
      headlineMedium: TextStyle(color: Colors.white),
      headlineSmall: TextStyle(color: Colors.white),
      titleLarge: TextStyle(color: Colors.white),
      titleMedium:TextStyle(color: Colors.white) ,
      titleSmall: TextStyle(color: Colors.white),
      labelLarge: TextStyle(color: Colors.white),
      labelMedium:TextStyle(color: Colors.white) ,
      labelSmall: TextStyle(color: Colors.white),
    ),
    scaffoldBackgroundColor: myColors.darkCard,
  );
 }