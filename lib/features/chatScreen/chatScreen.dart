import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/Firebase/FirebaseAuth.dart';
import 'package:whatsappclone/colorPicker/colorsList.dart';
import 'package:whatsappclone/components/TextStyles.dart';
import 'package:whatsappclone/components/flutterToast.dart';
import 'package:whatsappclone/components/iconButton.dart';
import 'package:whatsappclone/core/icons.dart';
import '../../components/TextField.dart';
import '../../components/imageNetworkComponent.dart';
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
  late final TextEditingController messageController = TextEditingController()
    ..addListener(() {
      setState(() {
        isTextEmpty = messageController.text.trim().isEmpty;
      });
    });
  final FirebaseService service = FirebaseService();
  User? user = FirebaseAuth.instance.currentUser;
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
                          receiverId: widget.receiverId
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
                  textColor: textColor,
                  user: user,
                  widget: widget,
                  onReply: setReplyMessage,
                  controller: messageController
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
                          style: Textstyles.reply,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (_replyMessage!.image != null && _replyMessage!.image!.isNotEmpty)
                        Image.network("${_replyMessage!.image}",height: 50, width: 60,),
                      kIconButton(
                        myIcon: icons.Wclose,
                        onPressed: (){
                          setState(() {
                            _replyMessage = null;
                            FocusScope.of(context).unfocus();
                          });
                        }
                      ),
                    ],
                  ),
                ),

              Padding(
                padding:  EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: kTextField(
                        myController: messageController,
                        hint: "Add a message",
                        hintStyle: TextStyle(color: textColor, fontSize: 15.7)
                      ),
                    ),
                    photoBtmSheet(service: service, widget: widget, textColor: textColor),
                    if (!isTextEmpty)
                      kIconButton(
                        onPressed: () {
                          service.sendMessage(widget.receiverId, widget.receiverName, messageController.text, null, null, _replyMessage);
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



