import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../globalState.dart';
import '../../messageClass/messageClass.dart';
import '../../Firebase/FirebaseAuth.dart';
import '../../components/TextField.dart';
import '../../components/flutterToast.dart';
import '../../components/iconButton.dart';
import '../../colorPicker/colorsList.dart';
import '../../components/TextStyles.dart';
import '../../core/icons.dart';
import 'Widgets/messageStream.dart';
import 'userDetails/recieverdetails.dart';
import 'Widgets/optionsBtmSheet.dart';

class Testname extends StatefulWidget {
  final String receiverId;
  final String receiverName;
  final String? senderId;
  final String? msg;
  const Testname({
    Key? key,
    required this.receiverId,
    required this.receiverName,  this.senderId, this.msg,
  }) : super(key: key);

  @override
  State<Testname> createState() => _TestnameState();
}

class _TestnameState extends State<Testname> {
  final TextEditingController messageController = TextEditingController();
  final FirebaseService service = FirebaseService();
  final User? user = FirebaseAuth.instance.currentUser;
  Messages? _replyMessage;
  bool isTextEmpty = true;

  void setReplyMessage(Messages message) {
    setState(() {
      _replyMessage = message;
      messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                        receiverId: widget.receiverId,
                      ),
                    ),
                  );
                } else {
                  myToast("There is no user.");
                }
              },
              child: AppBar(
                backgroundColor: color,
                title: Text(widget.receiverName, style: Textstyles.bioStyle),
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
                ),
              ),
              if (_replyMessage != null)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${_replyMessage!.senderEmail}\n${_replyMessage!.text}',
                          style: Textstyles.reply,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: kTextField(
                        myController: messageController,
                        hint: "Add a message",
                        hintStyle: TextStyle(color: textColor, fontSize: 15.7),
                      ),
                    ),
                    photoBtmSheet(service: service, widget: widget, textColor: textColor),
                    if (!isTextEmpty)
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
