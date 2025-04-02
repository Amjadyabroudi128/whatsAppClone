import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/Firebase/FirebaseAuth.dart';
import 'package:whatsappclone/components/iconButton.dart';
import 'package:whatsappclone/core/icons.dart';
import 'package:whatsappclone/core/MyColors.dart';
import 'package:whatsappclone/core/appTheme.dart';
import '../../components/TextField.dart';
import '../../globalState.dart';
import '../../messageClass/messageClass.dart';
import 'Widgets/messageStream.dart';

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

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await service.sendMessage(widget.receiverId, widget.receiverName, messageController.text,);
      messageController.clear();
    }
  }


  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: selectedThemeColor,
      builder: (context, color, child) {
        return Scaffold(
          backgroundColor: color,
          appBar: AppBar(
            backgroundColor: color,
            title: Text(widget.receiverName, style: const TextStyle(fontSize: 16)),
          ),
          body: Column(
            children: [
              Expanded(
                child: MessageStream(service: service, user: user, widget: widget),
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
                    kIconButton(onPressed: () {}, myIcon: icons.image, iconSize: 26),
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


