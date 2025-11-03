import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsappclone/Firebase/FirebaseAuth.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/TextButton.dart';
import 'package:whatsappclone/core/TextStyles.dart';
import 'package:whatsappclone/components/imageNetworkComponent.dart';
import 'package:whatsappclone/core/consts.dart';
import 'package:whatsappclone/core/icons.dart';
import 'package:whatsappclone/features/chatScreen/Model/MessageModel.dart';
import 'package:whatsappclone/features/chatScreen/Widgets/selectMessage.dart';
import 'package:whatsappclone/features/chatScreen/Widgets/starMessage.dart';
import 'package:whatsappclone/features/chatScreen/chatScreen.dart';
import 'package:whatsappclone/reactions/reactionCard.dart';
import '../../../core/MyColors.dart';
import '../../../core/appTheme.dart';
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
    this.msg,
  });

  final List<Messages> messages;
  final Messages? msg;
  final User? user;
  final Testname? widget;
  final void Function(Messages)? onReply;
  final Color? textColor;
  late final bool isEditing;
  final Set<String> selectedMessages;
  final VoidCallback? onToggleEdit;

  @override
  State<messagesAlign> createState() => _messagesAlignState();
}

class _messagesAlignState extends State<messagesAlign> {
  final bool isStarred = false;
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    FirebaseService service = FirebaseService();
    return GestureDetector(
      onTap: () {
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
          String today = DateFormat('dd/MM/yyyy').format(dateTime);
          bool showDate = false;
          if (index == 0) {
            showDate = true;
          } else {
            final prevTimestamp = widget.messages[index - 1].time;
            DateTime prevDate;
            if (prevTimestamp is Timestamp) {
              prevDate = prevTimestamp.toDate();
            } else {
              prevDate = DateTime.now();
            }

            final prevDay = DateFormat('dd/MM/yyyy').format(prevDate);
            showDate = today != prevDay;
          }
          return Column(
            children: [
              if (showDate)
                Text(
                  today,
                  style: TextStyle(color: widget.textColor),
                ),
              Align(
                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    if (msg.image != null && msg.image!.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Imagescreen(
                            image: msg.image,
                            date: today,
                            senderName: msg.senderName,
                            time: formattedTime,
                            messageId: msg.messageId,
                            receiverId: msg.receiverId,
                            senderId: msg.senderId,
                            senderEmail: msg.senderEmail,
                            receiverEmail: msg.receiverEmail,
                            isMe: isMe,
                          ),
                        ),
                      );
                    } else if (msg.file != null && msg.file!.isNotEmpty) {
                      launchUrl(Uri.parse('${msg.file}'));
                    }
                  },
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
                      detail.globalPosition.dy,
                      MediaQuery.of(context).size.width / 4,
                      0.0,
                    );
                    if (msg.image != null && msg.image!.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Imagescreen(
                            image: msg.image,
                            date: today,
                            senderName: msg.senderName,
                            time: formattedTime,
                            messageId: msg.messageId,
                            receiverId: msg.receiverId,
                            senderId: msg.senderId,
                            senderEmail: msg.senderEmail,
                            receiverEmail: msg.receiverEmail,
                            isMe: isMe,
                          ),
                        ),
                      );
                    } else if (msg.file != null && msg.file!.isNotEmpty) {
                      showMenu<String>(
                        context: context,
                        color: MyColors.menuColor,
                        position: position,
                        items: [
                          PopupMenuItem<String>(
                            value: 'open',
                            child: const Text('Open File'),
                            onTap: () async {
                              await launchUrl(Uri.parse('${msg.file}'));
                            },
                          ),
                          deleteMessage(context, msg, widget.widget, widget.user, service),
                        ],
                      );
                    } else {
                      showMenu(
                        context: context,
                        color: MyColors.menuColor,
                        position: position,
                        items: [
                          copyMessage(msg, context),
                          if (isMe) editMessage(context, msg, service, widget.widget, widget.user),
                          if (isMe) deleteMessage(context, msg, widget.widget, widget.user, service),
                          starMessage(msg, service, index, context),
                          PopupMenuItem(
                            value: "reaction",
                            child: kTextButton(
                              onPressed: (){
                                showMenu(
                                  context: context,
                                  position: position,
                                  items: [
                                    PopupMenuItem(
                                      padding: EdgeInsets.zero,
                                      child: ReactionCard(
                                        onReactionTap: (emoji) {
                                          service.addReaction(
                                              msg.senderId, msg.receiverId,
                                              msg.messageId, emoji, msg.senderName
                                          );
                                          setState(() {

                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                              child: const Row(
                                children: [
                                  Text("Add reaction"),
                                  Spacer(),
                                  Icon(Icons.face)
                                ],
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            value: "reply",
                            child: kTextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                if (widget.onReply != null) {
                                  widget.onReply!(msg);
                                }
                              },
                              child: Row(
                                children: [
                                  Text("Reply", style: Textstyles.copyMessage),
                                  const Spacer(),
                                  icons.reply
                                ],
                              ),
                            ),
                          ),
                          selectMessage(
                            context,
                            msg,
                            widget.isEditing,
                            widget.onToggleEdit,
                            widget.selectedMessages,
                                () {
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
                            },
                          )
                        ],
                      );
                    }
                    FocusScope.of(Navigator.of(context).context).unfocus();
                  },
                  child: Dismissible(
                    direction: isMe
                        ? DismissDirection.endToStart
                        : DismissDirection.startToEnd,
                    background: Container(
                      alignment: isMe ? Alignment.centerLeft : Alignment.centerRight,
                      child: icons.reply,
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
                          (isMe)
                              ? Transform.scale(
                            scale: 1.2,
                            child: Checkbox(
                              activeColor: MyColors.starColor,
                              side: BorderSide(color: MyColors.labelClr),
                              visualDensity: VisualDensity.compact,
                              checkColor: MyColors.FG,
                              shape: const CircleBorder(),
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
                          )
                              : const SizedBox(),
                        Flexible(
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [ IntrinsicWidth(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width * 0.50,
                                ),

                                child: Container(
                                  margin: containermargin,
                                  decoration: containerDecoration(
                                    color: isMe ? MyColors.myMessage : Colors.grey,
                                    borderRadius: MyTheme.circularContainer,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (msg.replyTo != null)
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(8),
                                          margin: const EdgeInsets.only(bottom: 4),
                                          decoration: BoxDecoration(
                                            color: isMe ? MyColors.reply : MyColors.message,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border(
                                              left: BorderSide(
                                                color: isMe ? MyColors.myBorder : MyColors.otherBorder,
                                                width: 7,
                                              ),
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${msg.replyTo!.senderEmail == FirebaseAuth.instance.currentUser!.email ? "You" : msg.replyTo!.senderName}",
                                                style: TextStyle(
                                                  color: msg.replyTo!.senderEmail == FirebaseAuth.instance.currentUser!.email
                                                      ? MyColors.myName
                                                      : MyColors.otherName,
                                                ),
                                              ),
                                              if (msg.replyTo!.image != null && msg.replyTo!.image!.isNotEmpty)
                                                Row(
                                                  children: [
                                                    icons.Wphoto,
                                                    const BoxSpacing(mWidth: 10),
                                                    Text("Photo", style: Textstyles.photo),
                                                    const Spacer(),
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(8),
                                                      child: Image.network(msg.replyTo!.image!, height: 60),
                                                    ),
                                                  ],
                                                ),
                                              Text(
                                                msg.replyTo!.text,
                                                style: Textstyles.textMsg,
                                              ),
                                            ],
                                          ),
                                        ),
                                      if (msg.image != null && msg.image!.isNotEmpty)
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // msg.image is a Firebase download URL
                                              kimageNet(src: msg.image!),
                                              if (msg.text.trim().isNotEmpty)
                                                const SizedBox(height: 8),
                                              if (msg.text.trim().isNotEmpty)
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 11, bottom: 8),
                                                  child: Text(
                                                    msg.text,
                                                    softWrap: true,
                                                    textAlign: TextAlign.right,
                                                    overflow: TextOverflow.clip,
                                                    style: Textstyles.textMsg,
                                                  ),
                                                )
                                            ],
                                          ),
                                        )
                                      else if (msg.file != null && msg.file!.isNotEmpty)
                                        Row(
                                          children: [
                                            icons.myFile,
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                msg.file!.split('/').last,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  decoration: TextDecoration.underline,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        )
                                      else
                                        Padding(
                                          padding: const EdgeInsets.all(9.0),
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              msg.text,
                                              softWrap: true,
                                              textAlign: TextAlign.right,
                                              overflow: TextOverflow.clip,
                                              style: Textstyles.textMsg,
                                            ),
                                          ),
                                        ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (msg.isEdited == true)
                                            Text("Edited", style: Textstyles.edited),
                                          const BoxSpacing(mWidth: 5),
                                          isMe
                                              ? (msg.isRead! ? icons.messageRead : icons.sent)
                                              : const SizedBox.shrink(),
                                          fomattedDateText(formattedTime: formattedTime),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                              if(msg.isReacted == true)
                                GestureDetector(
                                  onTap: (){

                                  },
                                  child: Positioned(
                                    top: -6,
                                    child: Text(
                                      "${msg.reactionEmoji}",
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),

                            ]
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
