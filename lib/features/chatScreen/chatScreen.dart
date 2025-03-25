
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/iconButton.dart';
import 'package:whatsappclone/core/icons.dart';
import 'package:whatsappclone/core/MyColors.dart';
import 'package:whatsappclone/core/appTheme.dart';
import '../../components/TextField.dart';
import '../../globalState.dart';
import '../../messageClass/messageClass.dart';

class Testname extends StatefulWidget {
  final String? username;

  const Testname({super.key, this.username});

  @override
  State<Testname> createState() => _TestnameState();
}

class _TestnameState extends State<Testname> {
  final TextEditingController messageController = TextEditingController();

  // Get current user
  User? user = FirebaseAuth.instance.currentUser;

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      setState(() {
        messages.add(Messages(text: messageController.text, isme: true));
        messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: selectedThemeColor, // Listen to theme changes
      builder: (context, color, child) {
        return Scaffold(
          backgroundColor: color, // Use the selected color
          appBar: AppBar(
            backgroundColor: color,
            automaticallyImplyLeading: true,
            title: Text("${widget.username}", style: const TextStyle(fontSize: 16)),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Align(
                            child: Text(messages[index].isme
                                ? "${widget.username ?? 'Unknown'}" // Show user email
                                : "User B"),
                            alignment: messages[index].isme
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                          ),
                          Align(
                            alignment: messages[index].isme
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: messages[index].isme
                                    ? myColors.myMessage
                                    : myColors.message,
                                borderRadius: myTheme.CircularContainer,
                              ),
                              child: Text(messages[index].text),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(9.0),
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

