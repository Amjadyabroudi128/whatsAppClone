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
      await service.sendMessage(widget.receiverId, widget.receiverName, messageController.text);
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
                child: StreamBuilder(
                  stream: service.getMessages(user!.uid, widget.receiverId),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text("No messages yet"));
                    }
                    var messages = snapshot.data!.docs.map((doc) => Messages(
                      text: doc["message"],
                      senderId: doc["senderId"],
                      receiverId: doc["receiverId"],
                      senderEmail: doc["senderEmail"],
                      receiverEmail: doc["receiverEmail"],
                    )).toList();

                    return ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        bool isMe = msg.senderId == user!.uid;
                        return Align(
                          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isMe ? myColors.myMessage : myColors.message,
                              borderRadius: myTheme.CircularContainer,
                            ),
                            child: Text(msg.text),
                          ),
                        );
                      },
                    );
                  },
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
