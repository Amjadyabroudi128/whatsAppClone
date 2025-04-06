import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/Firebase/FirebaseAuth.dart';
import 'package:whatsappclone/components/TextStyles.dart';
import 'package:whatsappclone/components/flutterToast.dart';
import 'package:whatsappclone/components/popUpMenu.dart';
import 'package:whatsappclone/core/consts.dart';
import 'package:whatsappclone/core/icons.dart';
import 'package:whatsappclone/features/chatScreen/chatScreen.dart';

import '../../../core/MyColors.dart';
import '../../../core/appTheme.dart';
import '../../../messageClass/messageClass.dart';
import 'package:intl/intl.dart';

import 'alertDialog.dart';
import 'deleteMessage.dart';
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
    return ListView.builder(
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
                    if (isMe) {
                      showMenu <String>(
                        context: context,
                      color: Colors.grey[350],
                      position: RelativeRect.fromLTRB(
                        detail.globalPosition.dy,
                        detail.globalPosition.dy,
                        0.0,
                        0.0
                      ),
                      items: [
                        PopupMenuItem(
                            value: 'edit',
                            child: TextButton(
                              onPressed: (){},
                              child: Row(
                                children: [
                                  Text("Edit",style: TextStyle(color: Colors.black),),
                                  Spacer(),
                                  Icon(Icons.edit, color: Colors.black,),
                                ],
                              ),
                            )
                        ),
                        deleteMessage(context),
                        PopupMenuItem(
                            value: 'Copy',
                            child: TextButton(
                              onPressed: (){},
                              child: Row(
                                children: [
                                  Text("Copy",style: TextStyle(color: Colors.black),),
                                  Spacer(),
                                  icons.copy,
                                ],
                              ),
                            )
                        ),
                      ],
                      );

                      // showDialog(
                      //   context: context,
                      //   builder: (context) => myDialog(msg: msg, service: service, user: user, widget: widget),
                      // );
                    } else {
                      myToast("You can only modify your own messages");
                    }
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
                        Text(msg.text),
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
    );
  }

}

