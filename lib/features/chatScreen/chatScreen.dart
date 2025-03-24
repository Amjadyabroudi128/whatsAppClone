import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/colorList/colorsList.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/iconButton.dart';
import 'package:whatsappclone/components/popUpMenu.dart';
import 'package:whatsappclone/core/icons.dart';
import 'package:whatsappclone/core/MyColors.dart';
import 'package:whatsappclone/core/appTheme.dart';
import '../../components/TextField.dart';
import '../../enums/enums.dart';
import '../../messageClass/messageClass.dart';

class Testname extends StatefulWidget {
  final String username;
  const Testname({super.key, required this.username}); // Fixed the syntax error

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
  Color scaffold = Colors.white;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffold,
      appBar: AppBar(
        backgroundColor: scaffold,
        automaticallyImplyLeading: true,
        title: Text("${widget.username}", style: TextStyle(fontSize: 16),), // Display user email
        actions: [
          MyPopUpMenu<Color>(
            icon: Icon(Icons.color_lens),
            itemBuilder: (context) {
              return colorNames.keys.map((Color color) {
                return PopupMenuItem<Color>(
                  value: color,
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: color,
                      ),
                      BoxSpacing(mWidth: 10,),
                      Text(colorNames[color]!),
                    ],
                  ),
                );
              }).toList();
            },
            onSelected: (Color color) {
              setState(() {
                scaffold = color;
              });
            },
          )

        ],
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
                            : "User B"
                        ),
                        alignment: messages[index].isme
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                      ),
                      Align(
                        alignment: messages[index].isme
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.all(10.0),
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
  }
}
