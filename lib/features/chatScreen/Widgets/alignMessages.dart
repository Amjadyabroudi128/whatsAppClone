import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whatsappclone/Firebase/FirebaseAuth.dart';
import 'package:whatsappclone/components/TextStyles.dart';
import 'package:whatsappclone/components/flutterToast.dart';
import 'package:whatsappclone/components/imageNetworkComponent.dart';
import 'package:whatsappclone/components/popUpMenu.dart';
import 'package:whatsappclone/core/consts.dart';
import 'package:whatsappclone/core/icons.dart';
import 'package:whatsappclone/features/chatScreen/chatScreen.dart';

import '../../../core/MyColors.dart';
import '../../../core/appTheme.dart';
import '../../../messageClass/messageClass.dart';
import 'package:intl/intl.dart';

import 'copyMessage.dart';
import 'deleteMessage.dart';
import 'editMessage.dart';
class messagesAlign extends StatelessWidget {
  const messagesAlign({
    super.key,
    required this.messages,
    required this.user,
     this.widget,
  });

  final List<Messages> messages;
  final User? user;
  final Testname? widget;
  @override
  Widget build(BuildContext context) {
    FirebaseService service = FirebaseService();
    return GestureDetector(
      onTap: (){
         FocusScope.of(context).unfocus();

      },
      child: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final msg = messages[index];
          bool isMe = msg.senderId == user!.uid;
          final timestamp = msg.time;
          DateTime? dateTime;

          if (timestamp is Timestamp) {
            dateTime = timestamp.toDate();
          } else if (timestamp is DateTime) {
            dateTime = timestamp;
          } else {
            dateTime = DateTime.now();
          }

          String formattedTime = DateFormat.Hm().format(dateTime!);
          String day = DateFormat.yMd().format(dateTime);
          return SingleChildScrollView(
            child: Column(
              children: [
                Text(day),
                Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: GestureDetector(
                    onTapDown: (detail) {
                      FocusScope.of(context).unfocus();
                      final position = isMe
                          ? RelativeRect.fromLTRB(
                        detail.globalPosition.dx,
                        detail.globalPosition.dy,
                        0.0,
                        0.0,
                      )
                          : RelativeRect.fromLTRB(
                        detail.globalPosition.dx,
                        detail.globalPosition.dy ,
                        MediaQuery.of(context).size.width / 4,
                        0.0,
                      );

                      showMenu<String>(
                        context: context,
                        color: myColors.menuColor,
                        position: position,
                        items: [
                          copyMessage(msg, context),
                          if (isMe) editMessage(context, msg, service, widget, user),
                          deleteMessage(context, msg, widget, user, service),
                        ],
                      );
                    },
                    child: Container(
                      margin:  containermargin,
                      padding:  containerPadding,
                      decoration: containerDecoration(
                        color: isMe ? myColors.myMessage : myColors.message,
                        borderRadius: myTheme.CircularContainer,
                      ),
                      child: Column(
                        children: [
                          if (msg.image != null && msg.image!.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: kimageNet(
                                src: msg.image!,
                                height: 200,
                                width: 200,
                                fit: BoxFit.cover,
                              ),
                            )
                          else
                            Text(
                              msg.text,
                              style: TextStyle(fontSize: 16),
                            ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 45,
                            ),
                            child: Text(formattedTime),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }


}

