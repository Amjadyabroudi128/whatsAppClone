
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/fontWeightHelper.dart';
import 'package:whatsappclone/core/MyColors.dart';
class Textstyles {
  static TextStyle welcome = TextStyle(fontSize: 22, fontWeight: fontWeightHelper.bold);
  static TextStyle privacy = TextStyle(color: myColors.TC);
  static TextStyle read = TextStyle(fontSize: 20, color: myColors.familyText);
  static TextStyle haveAccount = TextStyle(fontSize: 15);
  static TextStyle hintStyle = TextStyle(color: Colors.black87, fontSize: 16);
  static TextStyle label = TextStyle(color: myColors.labelClr, fontSize: 15);
  static TextStyle floating = TextStyle(fontSize: 25, color: myColors.floating);
  static TextStyle appBar = TextStyle(color: myColors.FG, fontWeight: fontWeightHelper.appBar);
  static TextStyle Ebtn =  TextStyle(fontSize: 18);
  static TextStyle settings = TextStyle(fontSize: 20, fontWeight: fontWeightHelper.bold, letterSpacing: 1);
  static TextStyle deleteStyle = TextStyle(fontSize: 19, color: myColors.delete);
  static TextStyle themeStyle = TextStyle(color: Colors.grey[500], fontSize: 16);
 }