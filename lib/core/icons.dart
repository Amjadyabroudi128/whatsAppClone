
 import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whatsappclone/core/MyColors.dart';
import 'appTheme.dart';

class icons {
  static Icon emailIcon(BuildContext context) {
    return Icon(
      Icons.email,
      color: Theme.of(context).iconTheme.color,
    );
  }
  static Icon passIcon = const Icon(Icons.password);
  static Icon name = const Icon(Icons.person);
  static Icon logout = Icon(Icons.logout,color: MyColors.delete,);
  static Icon image(BuildContext context) {
    return Icon(
      CupertinoIcons.photo,
      color: Theme.of(context).iconTheme.color,
    );
  }  static Icon whiteImage(BuildContext context) {
    return Icon(
      CupertinoIcons.photo,
      color: Theme.of(context).iconTheme.color,
    );
  }
  static Icon send = Icon(Icons.send,color: MyColors.myMessage);
  static Icon arrow = const Icon(Icons.arrow_back);
  // static Icon add = const Icon(Icons.add);
  static Icon add(BuildContext context, Color? color) {
    return Icon(
      Icons.add,
      color: color,
      // color: Theme.of(context).iconTheme.color,
    );
  }
  static Icon visibility = const Icon(Icons.visibility);
  static Icon visibility_off = const Icon(Icons.visibility_off);
  static Icon contacts = const Icon(CupertinoIcons.person);
  static Icon chats = const Icon(Icons.chat);
  static Icon settings = const Icon(Icons.settings);
  static Icon person(BuildContext context) {
    return Icon(
      Icons.person,
      size: 30,
      color: Theme.of(context).iconTheme.color,
    );
  }
  static Icon arrowForward(BuildContext context){
    return Icon(
        Icons.arrow_forward_ios,
      color: Theme.of(context).iconTheme.color,
    );
  }
  static Icon remove(BuildContext context) {
    return Icon(
      Icons.remove_circle,
      color: Theme.of(context).iconTheme.color,
    );
  }
  static Icon tick = Icon(Icons.check, color: MyColors.tick, size: 40);
  static Icon colors = const Icon(Icons.color_lens_outlined);
  static Icon deleteIcon = Icon(CupertinoIcons.delete, color: MyColors.delete);
  static Icon copy(BuildContext context) {
    return Icon(
      Icons.copy,
      color: Theme.of(context).iconTheme.color,
    );
  }
  // static Icon copy = Icon(Icons.copy,color: MyTheme.appTheme == true ? Colors.white : Colors.black,);
  static Icon wcopy = const Icon(Icons.copy, color: Colors.white,);
  static Icon edit = Icon(CupertinoIcons.pencil, color: MyColors.tick, size: 27,);
  static Icon camera(BuildContext context) {
    return Icon(
      CupertinoIcons.camera,
      color: Theme.of(context).iconTheme.color,
    );
  }
  static Icon cancel = const Icon(Icons.cancel_outlined,);
  static Icon dCam = const Icon(Icons.camera_alt_outlined);
  static Icon file(BuildContext context) {
    return Icon(Icons.file_copy_outlined,
      color: Theme.of(context).iconTheme.color,
    );
  }
  static Icon star(BuildContext context) {
    return Icon(
      Icons.star_border_outlined, color: Theme.of(context).iconTheme.color,
    );
  }
  static Icon noStar = Icon(Icons.stars, color: MyColors.starColor, size: 90,);
  static Icon wStar = const Icon(Icons.star, color: Colors.white,size: 18,);
  static Icon slash(BuildContext context) {
    return Icon(
      CupertinoIcons.star_slash_fill, size: 30,
      color: Theme.of(context).iconTheme.color,
    );
  }
  // static Icon stary = const Icon(CupertinoIcons.star, size: 30,);
  static Icon stary(BuildContext context) {
    return Icon(CupertinoIcons.star, size: 30,color:Theme.of(context).iconTheme.color,);
  }
  static Icon amberStar = Icon(Icons.star, color: MyColors.amberStar);
  static Icon noImages = const Icon(CupertinoIcons.photo, size: 50,);
  static Icon supportedImage = const Icon(Icons.image_not_supported, size: 50, color: Colors.grey);
  static Icon share(BuildContext context) {
    return Icon(
      CupertinoIcons.share,
      color: Theme.of(context).iconTheme.color,
    );
  }
  static Icon close = const Icon(Icons.close);
  static Icon Wclose = const Icon(Icons.close, color: Colors.white,);
  static Icon reply = Icon(Icons.reply, color: MyColors.labelClr,);
  static Icon Wphoto = const Icon(CupertinoIcons.photo, size: 20,color: Colors.white,);
  static Icon selectIcon = Icon(Icons.check_circle_outline, color: MyColors.labelClr);
  static Icon search = const  Icon(Icons.search);
  static Icon instagram(BuildContext context) {
    return Icon(
        FontAwesomeIcons.instagram,
      color: Theme.of(context).iconTheme.color,
    );
  }
  static Icon messageRead = Icon(Icons.done_all, color: MyColors.readColor);
  static Icon sent = Icon(Icons.check, color: MyColors.sent,);
  static Icon unread = const Icon(Icons.mark_chat_unread, size: 23, color: Colors.white,);
  static Icon read = const Icon(Icons.mark_chat_read_outlined);
  static Icon options =  const Icon(Icons.more_horiz_outlined, size: 27,);
  static Icon fave(BuildContext context) {
    return  Icon(
      Icons.favorite_border,
      color: Theme.of(context).iconTheme.color,
    );
  }
  static Icon mute(BuildContext context) {
    return  Icon(
      Icons.volume_off_outlined,
      color: Theme.of(context).iconTheme.color,
    );
  }
  static Icon myFile = const Icon(Icons.insert_drive_file, color: Colors.blue);
  static Icon volumeUp(BuildContext context) {
    return  Icon(
      Icons.volume_up,
      color: Theme.of(context).iconTheme.color,
    );
  }
  static Icon myFavourite(BuildContext context, {double? size}) {
    return Icon(Icons.favorite, color: Theme.of(context).iconTheme.color, size: size,);
  }
  static Icon getIssueIcon(BuildContext context) {
    return Icon(
      CupertinoIcons.exclamationmark_circle,
      color: Theme.of(context).iconTheme.color,
    );
  }
  static Icon thanks(BuildContext context) {
    return Icon(Icons.check_circle_outline, size: 72, color: Theme.of(context).iconTheme.color,);
  }
  static Icon onlineStatus =  Icon(Icons.check_circle,color: MyColors.online, size: 25,);
  static Icon reaction = const Icon(Icons.face_2);
}