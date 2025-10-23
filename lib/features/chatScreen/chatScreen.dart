import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whatsappclone/components/TextButton.dart';
import 'package:whatsappclone/components/btmSheet.dart';
import 'package:whatsappclone/components/kCard.dart';
import 'package:whatsappclone/components/listTilesOptions.dart';
import 'package:whatsappclone/core/MyColors.dart';
import 'package:whatsappclone/core/consts.dart';
import 'package:whatsappclone/features/chatScreen/Model/MessageModel.dart';
import 'package:whatsappclone/features/chatScreen/Widgets/messageStream.dart';
import 'package:whatsappclone/features/chatScreen/Widgets/optionsBtmSheet.dart';
import 'package:whatsappclone/features/chatScreen/userDetails/recieverdetails.dart';
import '../../globalState.dart';
import '../../Firebase/FirebaseAuth.dart';
import '../../components/TextField.dart';
import '../../components/flutterToast.dart';
import '../../components/iconButton.dart';
import '../../colorPicker/colorsList.dart';
import '../../core/TextStyles.dart';
import '../../core/icons.dart';

class Testname extends StatefulWidget {
  final String receiverId;
  final String receiverName;
  final String? senderId;
  final String? msg;
  final String? image;

  const Testname({
    Key? key,
    required this.receiverId,
    required this.receiverName,
    this.senderId,
    this.msg,
    this.image,
  }) : super(key: key);

  @override
  State<Testname> createState() => _TestnameState();
}

class _TestnameState extends State<Testname> {
  final TextEditingController messageController = TextEditingController();
  final FirebaseService service = FirebaseService();
  final User? user = FirebaseAuth.instance.currentUser;
  final currentUser = FirebaseAuth.instance.currentUser!.uid;

  Messages? _replyMessage;
  bool isEditing = false;
  bool isUploading = false;
  Set<String> selectedMessages = {};

  void setReplyMessage(Messages message) {
    setState(() {
      _replyMessage = message;
    });
  }

  void markMessagesAsRead() async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final chatRoomId = getChatRoomId(currentUserId, widget.receiverId);

    final unreadMessages = await FirebaseFirestore.instance
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .where("receiverId", isEqualTo: currentUserId)
        .where("isRead", isEqualTo: false)
        .get();

    for (final doc in unreadMessages.docs) {
      await doc.reference.update({"isRead": true});
    }
  }

  String getChatRoomId(String user1, String user2) {
    final ids = [user1, user2]..sort();
    return ids.join("_");
  }

  // Update typing status in Firestore
  void updateTypingStatus(bool isTyping) {
    if (user == null) return;

    service.updateUserTypingStatus(
      isTyping: isTyping,
      typingToUserId: isTyping ? widget.receiverId : null,
    );
  }

  @override
  void initState() {
    super.initState();
    markMessagesAsRead();
    service.readMsg(widget.receiverId);
    messageController.addListener(() {
      // Update typing status based on text field content
      updateTypingStatus(messageController.text.trim().isNotEmpty);
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Clear typing status when leaving chat
    updateTypingStatus(false);
    messageController.removeListener(() {});
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isReplyFromMe = _replyMessage?.senderEmail == user!.email;
    final OutlineInputBorder messageBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.black),
    );

    return ValueListenableBuilder<Color>(
      valueListenable: selectedThemeColor,
      builder: (context, color, child) {
        final textColor = getTextColor(color);
        return Scaffold(
          backgroundColor: color,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: GestureDetector(
              onTap: () async {
                final snapshot = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.receiverId)
                    .get();

                if (snapshot.exists) {
                  final data = snapshot.data();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => userDetails(
                        name: data?['name'] ?? '',
                        email: data?['email'] ?? '',
                        imageUrl: data?['image'] ?? '',
                        bio: data?["bio"] ?? '',
                        link: data?["link"] ?? "",
                        receiverId: widget.receiverId,
                      ),
                    ),
                  );
                } else {
                  myToast("There is no user.");
                }
              },
              child: AppBar(
                title: isEditing
                    ? Row(
                  children: [
                    const Text("Selected"),
                    const Spacer(),
                    kTextButton(
                      onPressed: () {
                        setState(() {
                          FocusScope.of(context).unfocus();
                          selectedMessages.clear();
                          isEditing = false;
                        });
                      },
                      child: const Text("Cancel"),
                    ),
                  ],
                )
                    : Row(
                  children: [
                    if (widget.image != null && widget.image!.isNotEmpty)
                      CircleAvatar(
                        backgroundImage: NetworkImage(widget.image!),
                        radius: 20,
                      )
                    else
                      icons.person(context),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.receiverName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                            stream: service.presenceStream(widget.receiverId),
                            builder: (context, snap) {
                              if (!snap.hasData || !snap.data!.exists) {
                                return const SizedBox.shrink();
                              }

                              final data = snap.data!.data()!;
                              final visibility = data['onlineVisibility'] as String? ?? 'Everyone';

                              // Hide if user set visibility to "Nobody"
                              if (visibility == 'Nobody') {
                                return const SizedBox.shrink();
                              }

                              final bool isOnline = data['isOnline'] == true;
                              final raw = data['lastSeen'] ?? data['LastSeen'];
                              DateTime? lastSeen;
                              if (raw is Timestamp) {
                                lastSeen = raw.toDate();
                              }

                              // Check if the receiver is typing to ME (current user)
                              final isTypingTo = data['isTypingTo'] as String?;
                              final bool receiverIsTyping =
                                  isTypingTo == user!.uid;

                              String subtitle;
                              if (receiverIsTyping) {
                                subtitle = "Typing...";
                              } else if (isOnline) {
                                subtitle = "Online";
                              } else if (lastSeen != null) {
                                subtitle = "last seen On ${DateFormat('E HH:mm').format(lastSeen)}";
                              } else {
                                subtitle = "Offline";
                              }

                              return Text(
                                subtitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Textstyles.offline(
                                  context,
                                  receiverIsTyping ? MyColors.familyText
                                      : isOnline ? MyColors.online : MyColors.offline,
                                    14
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                centerTitle: false,
              ),
            ),
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Column(
              children: [
                Expanded(
                  child: MessageStream(
                    service: service,
                    textColor: textColor,
                    user: user,
                    widget: widget,
                    onReply: setReplyMessage,
                    controller: messageController,
                    isEditing: isEditing,
                    selectedMessages: selectedMessages,
                    onToggleEdit: () {
                      setState(() {
                        isEditing = !isEditing;
                        selectedMessages.clear();
                      });
                    },
                  ),
                ),
                if (_replyMessage != null)
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    padding: const EdgeInsets.all(8),
                    decoration: replyDecoration(
                      color: MyColors.labelClr,
                      borderRadius: BorderRadius.circular(8),
                      border: Border(
                        left: BorderSide(
                          color: isReplyFromMe
                              ? MyColors.myReply
                              : MyColors.otherReply,
                          width: 7,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isReplyFromMe
                                    ? "You"
                                    : (_replyMessage!.senderName ?? ""),
                                maxLines: 2,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  color: isReplyFromMe
                                      ? MyColors.myName
                                      : MyColors.otherName,
                                ),
                              ),
                              Text(
                                _replyMessage!.text,
                                style: Textstyles.reply,
                                maxLines: 3,
                                overflow: TextOverflow.clip,
                              ),
                            ],
                          ),
                        ),
                        if (_replyMessage!.image != null &&
                            _replyMessage!.image!.isNotEmpty)
                          Image.network(
                            _replyMessage!.image!,
                            height: 50,
                            width: 60,
                          ),
                        kIconButton(
                          myIcon: icons.Wclose,
                          onPressed: () {
                            setState(() {
                              _replyMessage = null;
                              FocusScope.of(context).unfocus();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                isEditing || selectedMessages.isNotEmpty
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    kIconButton(
                      onPressed: () async {
                        final count = selectedMessages.length;
                        await btmSheet(
                          context: context,
                          builder: (context) {
                            return Wrap(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                        const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Delete $count Message${count > 1 ? 's' : ''}?",
                                              style: Textstyles
                                                  .deleteMessages,
                                            ),
                                            const Spacer(),
                                            kIconButton(
                                              myIcon: icons.close,
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop();
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      kCard(
                                        child: Options(
                                          label: Text(
                                            "Delete Messages",
                                            style:
                                            Textstyles.saveBio,
                                          ),
                                          trailing: icons.deleteIcon,
                                          onTap: () async {
                                            myToast("Message deleted");
                                            Navigator.of(context).pop();
                                            await service
                                                .deleteSelectedMessages(
                                              senderId: FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid,
                                              receiverId:
                                              widget.receiverId,
                                              messageIds:
                                              selectedMessages,
                                            );
                                            setState(() {
                                              isEditing = false;
                                              selectedMessages.clear();
                                            });
                                          },
                                          context: context,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      myIcon: icons.deleteIcon,
                    ),
                  ],
                )
                    : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: kTextField(
                          textColor: MyColors.labelClr,
                          enable: messageBorder,
                          focused: messageBorder,
                          myController: messageController,
                          hint: "Add a message",
                          hintStyle: Textstyles.sendMessage,
                        ),
                      ),
                      photoBtmSheet(
                        service: service,
                        widget: widget,
                        textColor: textColor,
                        onUploadStatusChanged: (value) {
                          setState(() {
                            isUploading = value;
                          });
                        },
                      ),
                      messageController.text.trim().isNotEmpty
                          ? kIconButton(
                        onPressed: () {
                          service.sendMessage(
                            widget.receiverId,
                            widget.receiverName,
                            messageController.text.trim(),
                            null,
                            null,
                            _replyMessage,
                          );
                          messageController.clear();
                          FocusScope.of(context).unfocus();
                          _replyMessage = null;
                          // Clear typing status after sending
                          updateTypingStatus(false);
                        },
                        myIcon: icons.send,
                      )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}