import 'package:flutter/material.dart';
import 'package:whatsappclone/components/icons.dart';
import 'package:whatsappclone/core/MyColors.dart';
import 'package:whatsappclone/core/appTheme.dart';
import 'package:whatsappclone/features/welcomeScreen/welcome.dart';
import '../../components/TextField.dart';
import '../../messageClass/messageClass.dart'; // Ensure the correct path

class Testname extends StatefulWidget {
  final String? name;
  const Testname({super.key, this.name});

  @override
  State<Testname> createState() => _TestnameState();
}

class _TestnameState extends State<Testname> {
  final TextEditingController messageController = TextEditingController();

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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WelcomeScreen(),
                ),
              );
            },
            icon: icons.logout,
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
                        child: Text(messages[index].isme ? "${widget.name}" :"User B"),
                        alignment: messages[index].isme ? Alignment.centerRight : Alignment.centerLeft,
                      ),
                      Align(
                        alignment: messages[index].isme ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: messages[index].isme ? myColors.myMessage : myColors.message,
                            borderRadius: myTheme.CircularContainer
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
                    hint: "add a message",
                  ),
                ),
                IconButton(onPressed: (){}, icon: icons.image, iconSize: 26,),
                IconButton(
                  onPressed: sendMessage,
                  icon: icons.send,
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
