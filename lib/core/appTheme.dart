

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
        foregroundColor: myColors.textBtn,
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
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Colors.black
    ),
    dialogTheme: DialogTheme(
      backgroundColor: Colors.black,
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