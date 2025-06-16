import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsappclone/Firebase/FirebaseAuth.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/TextButton.dart';
import 'package:whatsappclone/components/TextStyles.dart';
import 'package:whatsappclone/components/imageNetworkComponent.dart';
import 'package:whatsappclone/core/consts.dart';
import 'package:whatsappclone/core/icons.dart';
import 'package:whatsappclone/features/chatScreen/Widgets/selectMessage.dart';
import 'package:whatsappclone/features/chatScreen/Widgets/starMessage.dart';
import 'package:whatsappclone/features/chatScreen/chatScreen.dart';
import '../../../core/MyColors.dart';
import '../../../core/appTheme.dart';
import '../../../messageClass/messageClass.dart';
import 'package:intl/intl.dart';

import '../userDetails/imageScreen.dart';
import 'copyMessage.dart';
import 'dateText.dart';
import 'deleteMessage.dart';
import 'editMessage.dart';
class messagesAlign extends StatefulWidget {
   messagesAlign({
    super.key,
    required this.messages,
    required this.user,
     this.widget,
    this.onReply,
    this.textColor,
    required this.isEditing,
    required this.selectedMessages,
     required this.onToggleEdit,
     this.msg
   });

  final List<Messages> messages;
  final Messages? msg;
  final User? user;
  final Testname? widget;
  final void Function(Messages)? onReply;
  final Color? textColor;
  late bool isEditing;
  final Set<String> selectedMessages;
   final VoidCallback? onToggleEdit;

   @override
  State<messagesAlign> createState() => _messagesAlignState();
}

class _messagesAlignState extends State<messagesAlign> {
  final bool isStarred = false;
  bool isEditing = false;
  void _handleSelectMessage() {
    setState(() {
      if (widget.selectedMessages.contains(widget.msg!.messageId)) {
        widget.selectedMessages.remove(widget.msg!.messageId);
      } else {
        widget.selectedMessages.add(widget.msg!.messageId!);
        widget.onToggleEdit?.call();
      }
    });
  }
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
          return Column(
            children: [
              Text(day, style: TextStyle(color: widget.textColor),),
              Align(
                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: GestureDetector(
                  onLongPressStart: (detail) {
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Imagescreen(
                            image: msg.image,
                              date: day,
                            senderName: msg.senderEmail,
                            time: formattedTime,
                            messageId: msg.messageId,
                            receiverId: msg.receiverId,
                            senderId: msg.senderId,
                            senderEmail: msg.senderEmail,
                            receiverEmail: msg.receiverEmail,
                          ),
                        ),
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
                          deleteMessage(context, msg, widget.widget, widget.user, service,),
                          starMessage(msg, service, index, context, ),
                          PopupMenuItem(
                            value: "reply",
                            child:kTextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                if (widget.onReply != null) {
                                  widget.onReply!(msg); // Call the reply handler
                                }
                              },
                              child: Row(
                                children: [
                                  Text("Reply",style: Textstyles.copyMessage,),
                                  Spacer(),
                                  icons.reply
                                ],
                              ),
                            )
                          ),
                          selectMessage(context, msg, widget.isEditing, widget.onToggleEdit, widget.selectedMessages, () {
                            setState(() {
                                if (!widget.isEditing) {
                                  widget.onToggleEdit?.call();
                                }
                                if (widget.selectedMessages.contains(msg.messageId)) {
                                  widget.selectedMessages.remove(msg.messageId);
                                } else {
                                  widget.selectedMessages.add(msg.messageId!);
                                }
                            });
                          })
                        ]
                      );
                    }
                    FocusScope.of(context).unfocus();
                  },
                  child: Dismissible(
                    direction: isMe ? DismissDirection.endToStart : DismissDirection.startToEnd,
                    background: Container(
                      child: icons.reply,
                      alignment: isMe ? Alignment.centerLeft : Alignment.centerRight,
                    ),
                    confirmDismiss: (direction) async {
                      if (direction == direction) {
                        if (widget.onReply != null) {
                          widget.onReply!(msg);
                        }
                      }
                      return null;
                    },
                    key: ValueKey(msg.messageId),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (widget.isEditing)
                          Transform.scale(
                            scale: 1.2,
                            child: Checkbox(
                              activeColor: myColors.starColor,
                              visualDensity: VisualDensity.compact,
                              checkColor: myColors.FG,
                              shape: CircleBorder(),
                              value: widget.selectedMessages.contains(msg.messageId),
                              onChanged: (value) {
                                setState(() {
                                  if (value == true) {
                                    widget.selectedMessages.add(msg.messageId!);
                                  } else {
                                    widget.selectedMessages.remove(msg.messageId);
                                  }
                                });
                              },
                            ),
                          ),
                        Flexible(
                          child: Container(
                            margin:  containermargin,
                            padding:  containerPadding,
                            decoration: containerDecoration(
                              color: isMe ? myColors.myMessage : myColors.message,
                              borderRadius: myTheme.CircularContainer,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (msg.replyTo != null)
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    margin: const EdgeInsets.only(bottom: 4),
                                    decoration: BoxDecoration(
                                      color: isMe ? Colors.green[200] : myColors.message,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("${msg.replyTo!.senderEmail}"),
                                        if (msg.replyTo!.image != null && msg.replyTo!.image!.isNotEmpty)
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  icons.Wphoto,
                                                  BoxSpacing(mWidth: 10,),
                                                  Text("Photo", style: TextStyle(fontSize: 17, color: Colors.grey),),
                                                  BoxSpacing(mWidth: 40,),
                                                  ClipRRect(
                                                    child: Image.network("${msg.replyTo!.image}", height: 60,),
                                                    borderRadius: BorderRadius.circular(8),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        Text(
                                          msg.replyTo!.text,
                                          style: TextStyle(color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                  ),
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
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    msg.text,
                                    style: TextStyle(fontSize: 16, color: Colors.black),
                                  ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (msg.isEdited == true)
                                      Text(
                                        "Edited",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.grey.shade800,
                                        ),
                                      ),
                                    fomattedDateText(formattedTime: formattedTime,),
                                  ],
                                )

                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

}

