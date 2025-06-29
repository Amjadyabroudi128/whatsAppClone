import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/TextButton.dart';
import 'package:whatsappclone/components/imageNetworkComponent.dart';
import 'package:whatsappclone/core/MyColors.dart';

import '../../globalState.dart';
import '../../messageClass/messageClass.dart';
import '../../Firebase/FirebaseAuth.dart';
import '../../components/TextField.dart';
import '../../components/flutterToast.dart';
import '../../components/iconButton.dart';
import '../../colorPicker/colorsList.dart';
import '../../core/TextStyles.dart';
import '../../core/icons.dart';
import 'Widgets/messageStream.dart';
import 'userDetails/recieverdetails.dart';
import 'Widgets/optionsBtmSheet.dart';

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

  @override
  Widget build(BuildContext context) {
    final isReplyFromMe = _replyMessage?.senderEmail == user!.email;
    final OutlineInputBorder messageBorder = OutlineInputBorder(borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
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
                        link: data?["link"] ?? "", // Default value if "link" is missing
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
                    Text("Selected"),
                    BoxSpacing(mWidth: MediaQuery.of(context).size.width * 0.39,),
                    kTextButton(
                        onPressed: (){
                          setState(() {
                            FocusScope.of(Navigator.of(context).context).unfocus();
                            selectedMessages.clear();
                            isEditing = !isEditing;
                          });
                        },
                        child: Text("Cancel"))
                  ],
                ) :Row(
                  children: [
                    if(widget.image != null && widget.image!.isNotEmpty) 
                      CircleAvatar(
                      backgroundImage: NetworkImage(widget.image!),
                      radius: 20,
                    ) else icons.person,
                    SizedBox(width: 10,),
                    Text(widget.receiverName)
                  ],
                ),
                centerTitle: false,
              ),
            ),
          ),
          body: Column(
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
              if(isUploading)
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.all(7),
                  child: CircularProgressIndicator(),
                ),
              ),
              if (_replyMessage != null)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                    border: Border(
                      left: BorderSide(
                        color: isReplyFromMe ? myColors.myReply
                        : myColors.otherReply,
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
                              "${_replyMessage!.senderEmail}",
                              maxLines: 2,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                color: isReplyFromMe ? myColors.myName :
                                myColors.otherName,
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
                          await service.deleteSelectedMessages(
                              senderId: FirebaseAuth.instance.currentUser!.uid,
                              receiverId: widget.receiverId,
                              messageIds: selectedMessages);
                          setState(() {
                            isEditing = false;
                            selectedMessages.clear();
                          });
                        },
                        myIcon: icons.deleteIcon,
                      ),
                    ],
                  ) :
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: kTextField(
                        maxLines: null,
                        textColor: Colors.black,
                        enable: messageBorder,
                        focused: messageBorder,
                        myController: messageController,
                        hint: "Add a message",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 15.7),
                      ),
                    ),
                    photoBtmSheet(service: service, widget: widget, textColor: textColor,
                      onUploadStatusChanged: (value) {
                      setState(() {
                        isUploading = value;
                      });
                    },),
                      kIconButton(
                        onPressed: () {
                          service.sendMessage(
                            widget.receiverId,
                            widget.receiverName,
                            messageController.text,
                            null,
                            null,
                            _replyMessage,
                          );
                          messageController.clear();
                          FocusScope.of(context).unfocus();
                          _replyMessage = null;
                        },
                        myIcon: icons.send,
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
