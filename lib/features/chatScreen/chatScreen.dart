import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/Firebase/FirebaseAuth.dart';
import 'package:whatsappclone/components/ListTiles.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/TextStyles.dart';
import 'package:whatsappclone/components/iconButton.dart';
import 'package:whatsappclone/core/icons.dart';

import '../../components/TextField.dart';
import '../../components/listTilesOptions.dart';
import '../../globalState.dart';
import 'Widgets/messageStream.dart';
import 'package:whatsappclone/utils/pickImage.dart' as url;

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
      await service.sendMessage(widget.receiverId, widget.receiverName, messageController.text, null);
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
            title: Text(widget.receiverName, style: Textstyles.bioStyle),
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
                    kIconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (BuildContext context) {
                            return SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Choose an option",
                                      style: Textstyles.option,
                                    ),
                                    const BoxSpacing(myHeight: 10),
                                    Options(context, icons.image, Text("photo"), () async {
                                      Navigator.pop(context); // close the bottom sheet
                                      final imageUrl = await url.pickImage();
                                      if (imageUrl != null) {
                                        await service.sendMessage(widget.receiverId, widget.receiverName, "", imageUrl);
                                      }
                                    }),
                                    Options(context, icons.dCam, Text("Camera"), () async {
                                      Navigator.pop(context);
                                      final imageUrl = await url.takeImage();
                                      if (imageUrl != null) {
                                        await service.sendMessage(widget.receiverId, widget.receiverName, "", imageUrl);
                                      }
                                    }),

                                    Options(context, icons.file, Text("File"), (){
                                    }
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );

                      },
                      myIcon: icons.add,
                    ),
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


