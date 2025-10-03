
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/fontWeightHelper.dart';
import 'package:whatsappclone/core/MyColors.dart';
class Textstyles {
  static TextStyle welcome = TextStyle(fontSize: 22, fontWeight: fontWeightHelper.bold);
  static TextStyle privacy = TextStyle(color: MyColors.TC);
  static TextStyle read = TextStyle(fontSize: 20, color: MyColors.familyText);
  static TextStyle haveAccount = const TextStyle(fontSize: 15);
  static TextStyle hintStyle = TextStyle(color: MyColors.floating, fontSize: 16);
  static TextStyle label = TextStyle(color: MyColors.labelClr, fontSize: 15);
  static TextStyle floating = TextStyle(fontSize: 25, color: MyColors.floating);
  static TextStyle appBar = TextStyle(color: MyColors.FG, fontWeight: fontWeightHelper.appBar);
  static TextStyle Ebtn =  const TextStyle(fontSize: 18);
  static TextStyle settings = TextStyle(fontSize: 20, fontWeight: fontWeightHelper.bold, letterSpacing: 1);
  static TextStyle deleteStyle = TextStyle(fontSize: 19, color: MyColors.delete);
  static TextStyle themeStyle = TextStyle(color: Colors.grey[500], fontSize: 16);
  static TextStyle accountStyle = const TextStyle(fontSize: 17, color: Colors.grey);
  static TextStyle selectClr = const TextStyle(fontSize: 18, color: Colors.white);
  static TextStyle colorName = const TextStyle(color: Colors.white, fontSize: 16);
  static TextStyle deletemessage = TextStyle(fontSize: 17, color: MyColors.redAccent);
  static TextStyle editText = TextStyle(fontSize: 17, color: MyColors.editMessage);
  static TextStyle copyMessage = TextStyle(color: MyColors.editMessage, fontSize: 17);
  static TextStyle bioStyle = const TextStyle(fontSize: 16);
  static TextStyle saveBio = const TextStyle(fontSize: 18,);
  static TextStyle editProfile = const TextStyle(fontSize: 20);
  static TextStyle addPhoto = TextStyle(fontSize: 18, color: MyColors.tick);
  static TextStyle option = const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  static TextStyle recieverName = const TextStyle(fontSize: 25,color: Colors.black);
  static TextStyle recieverEmail = const TextStyle(fontSize: 18, letterSpacing: 2, color: Colors.black);
  static TextStyle noStarMessage = const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  static TextStyle editBar =  const TextStyle(fontSize: 19);
  static TextStyle btmSheet = const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  static TextStyle reply = const TextStyle( color: Colors.white, fontSize: 16);
  static TextStyle darkLabel =const TextStyle(color: Colors.white);
  static TextStyle insta = const TextStyle(fontSize: 13, color: CupertinoColors.systemGrey);
  static TextStyle photo = const TextStyle(fontSize: 17, color: Colors.grey);
  static TextStyle edited = TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: Colors.grey.shade800,);
  static TextStyle sendMessage = const TextStyle(color: Colors.black, fontSize: 15.7);
  static TextStyle chatNumber = const TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold, color: Colors.white,);
  static TextStyle unreadCount = const TextStyle(color: Colors.white, fontSize: 12);
  static TextStyle deleteMessages = const TextStyle(fontSize: 17, fontWeight: FontWeight.bold);
  static TextStyle important = const TextStyle(
      fontSize: 16, fontWeight: FontWeight.w500);
  static TextStyle textMsg = const TextStyle(fontSize: 16, color: Colors.black);
  static TextStyle thanks = const TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  static TextStyle report = const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  static TextStyle offline(BuildContext context, Color color, double fontsize){
    return TextStyle(
      color: color,
      fontSize: fontsize
    );
  }
 }