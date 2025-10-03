import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/SizedBox.dart';
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
    required this.receiverName,  this.senderId, this.msg, this.image,
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
  bool isTextEmpty = true;
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
        .where("receieverId", isEqualTo: currentUserId)
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    markMessagesAsRead();
    service.readMsg(widget.receiverId);
    messageController.addListener(() {
      setState(() {}); // Rebuild UI when text changes
    });
  }
  @override
  Widget build(BuildContext context) {
    final isReplyFromMe = _replyMessage?.senderEmail == user!.email;
    final OutlineInputBorder messageBorder = OutlineInputBorder(borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
            color: Colors.black
        )
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
                // backgroundColor: color,
                title: isEditing ? Row(
                  children: [
                    const Text("Selected"),
                    BoxSpacing(mWidth: MediaQuery.of(context).size.width * 0.39,),
                    kTextButton(
                        onPressed: (){
                          setState(() {
                            FocusScope.of(Navigator.of(context).context).unfocus();
                            selectedMessages.clear();
                            isEditing = !isEditing;
                          });
                        },
                        child: const Text("Cancel"))
                  ],
                ) :
                Row(
                  children: [
                    if (widget.image != null && widget.image!.isNotEmpty)
                      CircleAvatar(backgroundImage: NetworkImage(widget.image!), radius: 20)
                    else
                      icons.person(context),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.receiverName),
                        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                          stream: service.presenceStream(widget.receiverId),
                          builder: (context, snap) {
                            if (!snap.hasData || !snap.data!.exists) {
                              return const SizedBox.shrink();
                            }
                            final data = snap.data!.data()!;
                            final isOnline = (data['isOnline'] == true);
                            final timestamp = data["LastSeen"];

                            DateTime? dateTime;
                            if (timestamp is Timestamp) {
                              dateTime = timestamp.toDate();
                            } else if (timestamp is DateTime) {
                              dateTime = timestamp;
                            } else {
                              dateTime = DateTime.now();
                            }
                            String subtitle;
                            if (isOnline) {
                              subtitle ="Online";
                            } else {
                              subtitle = "offline";
                            }
                            return Text(
                              subtitle,
                              style: Textstyles.offline(context, isOnline ? MyColors.online : MyColors.offline, 13),
                              // style: TextStyle(fontSize: 13, color: isOnline ? Colors.green : Colors.red),
                            );
                          },
                        ),
                      ],
                    )
                  ],
                ),
                centerTitle: false,
              ),
            ),
          ),
          body: GestureDetector(
            onTap: (){
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
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    padding: const EdgeInsets.all(8),
                    decoration: replyDecoration(
                      color: MyColors.labelClr,
                      borderRadius: BorderRadius.circular(8),
                      border: Border(
                        left: BorderSide(
                          color: isReplyFromMe ? MyColors.myReply
                          : MyColors.otherReply,
                          width: 7
                        )
                      )
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isReplyFromMe ? "You" : (_replyMessage!.senderName ?? ""),
                                maxLines: 2,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  color: isReplyFromMe ? MyColors.myName :
                                  MyColors.otherName,
                                ),
                              ),
                              Text("${_replyMessage!.text}", style: Textstyles.reply,
                                maxLines: 3,overflow: TextOverflow.clip,
                              )
                            ],
                          ),
                        ),
                        if (_replyMessage!.image != null && _replyMessage!.image!.isNotEmpty)
                          Image.network(_replyMessage!.image!, height: 50, width: 60),
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
                isEditing || selectedMessages.isNotEmpty ?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        kIconButton(
                          onPressed: () async {
                            final count = selectedMessages.length;
                            await btmSheet(
                              context: context,
                              builder: (context) {
                                return Wrap(
                                  children: [ Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text("Delete $count Message${count > 1 ? 's' : ''}?",
                                                style: Textstyles.deleteMessages,),
                                              Spacer(),
                                              kIconButton(
                                                myIcon: icons.close,
                                                onPressed: (){
                                                  Navigator.of(context).pop();
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                        kCard(
                                          child: Options(
                                            label: Text("Delete Messages", style: Textstyles.saveBio),
                                            trailing: icons.deleteIcon,
                                            onTap: () async {
                                              myToast("message Deleted ");
                                              await service.deleteSelectedMessages(
                                                  senderId: FirebaseAuth.instance.currentUser!.uid,
                                                  receiverId: widget.receiverId,
                                                  messageIds: selectedMessages);
                                              Navigator.of(context).pop();
                                              setState(() {
                                                isEditing = false;
                                                selectedMessages.clear();
                                              });
                                            },
                                            context: context
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ]
                                );
                              }
                            );
                          },
                          myIcon: icons.deleteIcon,
                        )
                      ],
                    ) :
                Padding(
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
                      photoBtmSheet(service: service, widget: widget, textColor: textColor,
                        onUploadStatusChanged: (value) {
                        setState(() {
                          isUploading = value;
                        });
                      },),
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
                        },
                        myIcon: icons.send,
                      )
                          : SizedBox.shrink(),
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
