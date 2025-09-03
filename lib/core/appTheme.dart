
import 'package:flutter/material.dart';
import 'package:whatsappclone/core/TextStyles.dart';
import 'package:whatsappclone/core/MyColors.dart';

 class MyTheme {
   static OutlineInputBorder fieldBorder = OutlineInputBorder(borderRadius: BorderRadius.circular(10),
     borderSide: const BorderSide()
   );
   static OutlineInputBorder darkBorder = OutlineInputBorder(borderRadius: BorderRadius.circular(10),
       borderSide: const BorderSide(
           color: Colors.white
       )
   );
   static OutlinedBorder circular = RoundedRectangleBorder(
     borderRadius: BorderRadius.circular(10)
   );
   static BorderRadiusGeometry circularContainer = BorderRadius.circular(10);
   static ShapeBorder cardShape = RoundedRectangleBorder(
     borderRadius: BorderRadius.circular(10.0),
   );
  static final ThemeData appTheme = ThemeData().copyWith(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      iconTheme: IconThemeData(
          color: Colors.black
      )
    ),
      iconTheme: const IconThemeData(color: Colors.black),

      elevatedButtonTheme: ElevatedButtonThemeData(
         style: ElevatedButton.styleFrom(
             backgroundColor: MyColors.TC,
             foregroundColor: MyColors.FG,
             textStyle: Textstyles.Ebtn,
           shape: circular
         ),
       ),

    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: fieldBorder,
      focusedBorder: fieldBorder,
      focusColor: MyColors.labelClr,
      labelStyle: Textstyles.label,
      hintStyle: Textstyles.hintStyle,
      floatingLabelStyle: Textstyles.floating
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: MyColors.FAB,
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
      color: MyColors.dividerTheme,
      indent: 30
    ),
    cardTheme: CardThemeData(
      shape: cardShape,
      color: Colors.white60,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
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
    iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: Colors.black,
        )
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: MyColors.textSelection,
      selectionHandleColor: MyColors.textSelection,
      selectionColor: MyColors.textSelection
    ),
    checkboxTheme: const CheckboxThemeData(
      checkColor: WidgetStatePropertyAll(Colors.white),
      side: BorderSide(
        color: Colors.black
      ),
      visualDensity: VisualDensity.compact,
      shape: CircleBorder(),
    )
   );
  static final ThemeData darkTheme = ThemeData().copyWith(
    cardTheme: CardThemeData(
      shape: cardShape,
      color: Colors.grey[700],
    ),

    checkboxTheme: const CheckboxThemeData(
      checkColor: WidgetStatePropertyAll(Colors.white),
      side: BorderSide(
        color: Colors.white
      ),
      visualDensity: VisualDensity.compact,
      shape: CircleBorder(),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: MyColors.darkCard,
      foregroundColor: Colors.white,
      iconTheme: const IconThemeData(
          color: Colors.white
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          backgroundColor: MyColors.TC,
          foregroundColor: MyColors.FG,
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
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
              color: Colors.white
          )
      ),
      focusedBorder: darkBorder,
      errorBorder: darkBorder,
      fillColor: Colors.grey,
      focusColor: Colors.white,
      labelStyle: Textstyles.darkLabel,
      hintStyle: Textstyles.darkLabel,
      floatingLabelStyle: Textstyles.darkLabel,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: MyColors.textSelection,
      selectionHandleColor: MyColors.textSelection,
      selectionColor: MyColors.textSelection
    ),
    listTileTheme: const ListTileThemeData(
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
    dialogTheme: DialogThemeData(
      backgroundColor: MyColors.bDialog
    ),
    dividerTheme: DividerThemeData(
        color: MyColors.dividerTheme,
        indent: 30
    ),
    iconTheme: const IconThemeData(color: Colors.white),
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
    scaffoldBackgroundColor: MyColors.darkCard,
  );
 }