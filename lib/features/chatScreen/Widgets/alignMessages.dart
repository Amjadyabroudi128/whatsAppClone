import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsappclone/Firebase/FirebaseAuth.dart';
import 'package:whatsappclone/components/TextButton.dart';
import 'package:whatsappclone/components/TextStyles.dart';
import 'package:whatsappclone/components/flutterToast.dart';
import 'package:whatsappclone/components/imageNetworkComponent.dart';
import 'package:whatsappclone/components/popUpMenu.dart';
import 'package:whatsappclone/core/consts.dart';
import 'package:whatsappclone/core/icons.dart';
import 'package:whatsappclone/features/chatScreen/Widgets/starrMessage.dart';
import 'package:whatsappclone/features/chatScreen/chatScreen.dart';

import '../../../core/MyColors.dart';
import '../../../core/appTheme.dart';
import '../../../messageClass/messageClass.dart';
import 'package:intl/intl.dart';

import 'copyMessage.dart';
import 'dateText.dart';
import 'deleteMessage.dart';
import 'editMessage.dart';
class messagesAlign extends StatefulWidget {
  const messagesAlign({
    super.key,
    required this.messages,
    required this.user,
     this.widget,
  });

  final List<Messages> messages;
  final User? user;
  final Testname? widget;
  Stream<List<String>> getStarredMessageIdsStream(String userEmail) {
    return FirebaseFirestore.instance
        .collection("starred-messages")
        .doc(userEmail)
        .collection("messages")
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }
  @override
  State<messagesAlign> createState() => _messagesAlignState();
}

class _messagesAlignState extends State<messagesAlign> {
  bool isStarred = false;

  @override
  Widget build(BuildContext context) {
    FirebaseService service = FirebaseService();
    return GestureDetector(
      onTap: (){
         FocusScope.of(context).unfocus();
      },
      child: ListView.builder(
        itemCount: widget.messages.length,
        itemBuilder: (context, index) {
          final msg = widget.messages[index];
          bool isMe = msg.senderId == widget.user!.uid;
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
                      if(msg.image != null && msg.image!.isNotEmpty) {
                        showMenu<String>(
                        context: context,
                        color: myColors.menuColor,
                        position: position,
                        items: [
                          deleteMessage(context, msg, widget.widget, widget.user, service),
                        ],
                      );
                      } else if (msg.file != null && msg.file!.isNotEmpty) {
                        showMenu<String>(
                          context: context,
                          color: myColors.menuColor,
                          position: position,
                          items: [
                            PopupMenuItem<String>(
                              value: 'open',
                              child: const Text('Open File'),
                              onTap: () async {
                                await launchUrl(Uri.parse(
                                    '${msg.file}'));
                              },
                            ),
                            deleteMessage(context, msg, widget.widget, widget.user, service),
                          ],
                        );
                      }
                      else {
                        showMenu(context: context,
                          color: myColors.menuColor,
                          position: position,
                          items: [
                            copyMessage(msg, context),
                            if (isMe) editMessage(context, msg, service, widget.widget, widget.user),
                            deleteMessage(context, msg, widget.widget, widget.user, service),
                            PopupMenuItem(
                              value: "Star",
                              child: kTextButton(
                                child: Row(
                                  children: [
                                    Text(msg.isStarred == true ? "Unstar" : "Star", style: Textstyles.copyMessage),
                                    Spacer(),
                                    (msg.isStarred == true ? Icon(Icons.star, color: Colors.amber) : icons.star),
                                  ],
                                ),
                                onPressed: () async {
                                  if (msg.isStarred == true) {
                                    await service.deleteStar(msg);
                                    myToast("Message unstarred");
                                  } else {
                                    await service.addToStar(msg);
                                    myToast("Message starred");
                                  }
                                  setState(() {
                                    widget.messages[index] = Messages(
                                      text: msg.text,
                                      senderId: msg.senderId,
                                      receiverId: msg.receiverId,
                                      senderEmail: msg.senderEmail,
                                      receiverEmail: msg.receiverEmail,
                                      time: msg.time,
                                      messageId: msg.messageId,
                                      image: msg.image,
                                      file: msg.file,
                                      isStarred: !(msg.isStarred ?? false),
                                    );
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                            )
                          ]
                        );
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
                          if (msg.image != null && msg.image!.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: kimageNet(src: msg.image!),
                            )
                          else if (msg.file != null && msg.file!.isNotEmpty)
                            Row(
                              children: [
                                Icon(Icons.insert_drive_file, color: Colors.blue),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    msg.file!.split('/').last,
                                    style: TextStyle(fontSize: 16, decoration: TextDecoration.underline),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            )
                          else
                            Text(
                              msg.text,
                              style: TextStyle(fontSize: 16),
                            ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if(msg.isStarred == true) icons.star,
                              fomattedDateText(formattedTime: formattedTime,),

                            ],
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

