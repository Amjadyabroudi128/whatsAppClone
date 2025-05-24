import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/Firebase/FirebaseAuth.dart';
import 'package:whatsappclone/components/TextStyles.dart';
import 'package:whatsappclone/components/flutterToast.dart';
import 'package:whatsappclone/components/iconButton.dart';
import 'package:whatsappclone/core/icons.dart';
import '../../components/TextField.dart';
import '../../globalState.dart';
import '../../messageClass/messageClass.dart';
import 'Widgets/messageStream.dart';

import 'Widgets/optionsBtmSheet.dart';
import 'userDetails/recieverdetails.dart';

class Testname extends StatefulWidget {
  final receiverName;
  final  receiverId;

  const Testname({super.key, this.receiverName, this.receiverId});

  @override
  State<Testname> createState() => _TestnameState();
}

class _TestnameState extends State<Testname> {
  final TextEditingController messageController = TextEditingController();
  final FirebaseService service = FirebaseService();
  User? user = FirebaseAuth.instance.currentUser;
  Messages? _replyMessage;

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await service.sendMessage(
        widget.receiverId,
        widget.receiverName,
        messageController.text,
        null,
        null,
        _replyMessage  // Pass reply message info here
      );
      messageController.clear();
      setState(() {
        _replyMessage = null; // Clear reply message after sending
      });
    }
  }

  void setReplyMessage(Messages message) {
    setState(() {
      _replyMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: selectedThemeColor,
      builder: (context, color, child) {
        return Scaffold(
          backgroundColor: color,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: GestureDetector(
                onTap: () async {
                  final snapshot = await FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.receiverId)
                      .get();

                  if (snapshot.exists) {
                    final data = snapshot.data();
                    final name = data?['name'] ?? 'No Name';
                    final email = data?['email'] ?? 'No Email';
                    final image = data?['image'] ?? "";
                    final bio = data?["bio"] ?? "";
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => userDetails(
                          name: name,
                          email: email,
                          imageUrl: image,
                          bio: bio,

                        ),
                      ),
                    );
                  } else {
                    myToast("there is no user ");
                  }
                },
              child: AppBar(
                centerTitle: false,
                backgroundColor: color,
                title: Text(widget.receiverName, style: Textstyles.bioStyle,)
              ),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: MessageStream(
                  service: service,
                  user: user,
                  widget: widget,
                  onReply: setReplyMessage,
                ),
              ),

              // Show reply preview above the input field, if replying
              if (_replyMessage != null)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${_replyMessage!.senderEmail}\n${_replyMessage!.text}',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: icons.Wclose,
                        onPressed: () {
                          setState(() {
                            _replyMessage = null;
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
                      ),
                    ),
                    photoBtmSheet(service: service, widget: widget),
                    kIconButton(
                      onPressed: sendMessage,
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



