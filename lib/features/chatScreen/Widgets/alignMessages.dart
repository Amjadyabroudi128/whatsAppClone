import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                        editMessage(context, msg, service, widget, user),
                        deleteMessage(context, msg, widget, user, service),
                        PopupMenuItem(
                            value: 'Copy',
                            child: TextButton(
                              onPressed: (){
                                final value = ClipboardData(text: msg.text);
                                Clipboard.setData(value);
                                print("copied${msg.text}");
                              },
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

