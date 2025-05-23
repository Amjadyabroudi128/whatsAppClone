import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:whatsappclone/Firebase/FirebaseAuth.dart';
import 'package:whatsappclone/Firebase/FirebaseCollections.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/TextStyles.dart';
import 'package:whatsappclone/components/dividerWidget.dart';
import 'package:whatsappclone/components/iconButton.dart';
import 'package:whatsappclone/components/kCard.dart';
import 'package:whatsappclone/messageClass/messageClass.dart';

import '../../../components/TextButton.dart';
import '../../../components/flutterToast.dart';
import '../../../core/MyColors.dart';
import '../../../core/icons.dart';

class Starredmessages extends StatefulWidget {
  const Starredmessages({super.key});

  @override
  State<Starredmessages> createState() => _StarredmessagesState();
}

class _StarredmessagesState extends State<Starredmessages> {
  final auth = FirebaseAuth.instance;
  FirebaseService service = FirebaseService();
  bool isEditing = false;
  Set<String> selectedMessages = {};
   User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Starred messages"),
        centerTitle: true,
        actions: [
          kTextButton(
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
                selectedMessages.clear(); // Optional: clear selections when toggling
              });
            },
            child: Text(isEditing ? (selectedMessages.isNotEmpty ? "Done" : "Cancel") : "Edit",
                style: Textstyles.editBar
            ),
          )
        ],

      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: stars
              .doc(auth.currentUser!.email)
              .collection("messages")
              .orderBy("timestamp", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    icons.noStar,
                    BoxSpacing(myHeight: 9),
                    Text("No Starred Messages", style: Textstyles.noStarMessage),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text(
                        "Tap and hold on a message to Star it, to find it later.",
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            }
            return Stack(
              children:[ ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (_, index) {
                  final data = snapshot.data!.docs[index];
                  final msg = Messages(
                    text: data["message"],
                    time:  data["timestamp"],
                    senderEmail: data["senderEmail"],
                    messageId: data.id,
                    image: data.data().toString().contains("image")
                        ? data["image"]
                        : null,
                  );
                  final dateTime = (msg.time != null) ? msg.time!.toDate() : DateTime.now();
                  final formattedTime = DateFormat.Hm().format(dateTime);
                  final day = DateFormat.yMd().format(dateTime);
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              msg.senderEmail == auth.currentUser!.email ? "You" : msg.senderEmail ?? "",
                              style: TextStyle(fontSize: 15),
                            ),
                            Spacer(),
                            Text(day)
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isEditing)
                              Transform.scale(
                                scale: 1.2,
                                child: Checkbox(
                                  visualDensity: VisualDensity.compact,
                                  checkColor: myColors.FG,
                                  shape: CircleBorder(),
                                  value: selectedMessages.contains(msg.messageId),
                                  onChanged: (value) {
                                    setState(() {
                                      if (value == true) {
                                        selectedMessages.add(msg.messageId!);
                                      } else {
                                        selectedMessages.remove(msg.messageId);
                                      }
                                    });
                                  },
                                ),
                              ),
                            kCard(
                              color: msg.senderEmail == auth.currentUser!.email ?
                              myColors.starColor : myColors.familyText,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    msg.image != null
                                        ? Image.network(
                                      msg.image!,
                                      height: 150,
                                      width: 150,
                                      fit: BoxFit.cover,
                                    )
                                        : Text(msg.text),

                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        icons.wStar,
                                        BoxSpacing(mWidth: 4,),
                                        Text(formattedTime),

                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        divider(),
                      ],
                    ),
                  );
                },
              ),
                isEditing && selectedMessages.isNotEmpty ?
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      copyIcon(snapshot),
                      kIconButton(
                        onPressed: () async {
                          myToast("⭐ Message unstarred ");
                          for (var doc in snapshot.data!.docs) {
                            if (selectedMessages.contains(doc.id)) {
                              final msg = Messages(
                                text: doc["message"],
                                time: doc["timestamp"],
                                senderEmail: doc["senderEmail"],
                                messageId: doc.id,
                              );
                              await service.deleteStar(msg);
                            }
                          }
                          setState(() {
                            isEditing = !isEditing;
                            selectedMessages.clear();
                          });
                        },
                        myIcon: icons.slash,
                      ),
                      kIconButton(
                        onPressed: () async {
                          for( var doc in snapshot.data!.docs ) {
                            if (selectedMessages.contains(doc.id)) {
                              final msg = Messages(
                                messageId: doc.id,
                                text: doc["message"],
                                receiverId: doc["receiverId"]
                              );
                              await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("You are about to delete ${msg.text}"),
                                  content: Text("Are you sure? "),
                                  actions: [
                                    kTextButton(
                                      onPressed: () =>  Navigator.pop(context),
                                      child: Text("Cancel"),
                                    ),
                                    kTextButton(
                                      onPressed: () async {
                                        await service.Deletemessage(user!.uid, msg.receiverId ?? "", msg.messageId ?? "");
                                        await service.deleteStar(msg);
                                        Navigator.pop(context);
                                        myToast("Selected messages deleted");
                                      },
                                      child: Text("Delete", style: Textstyles.deletemessage,),
                                    )
                                  ],
                                )
                              );
                              setState(() {
                                isEditing = !isEditing;
                                selectedMessages.clear();
                              });

                            }
                          }
                        },
                        myIcon: icons.deleteIcon,
                      ),
                    ],
                  ),
                ) : SizedBox.shrink()
            ]
            );
          },
        ),
      ),
    );
  }

  kIconButton copyIcon(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    return kIconButton(
      onPressed: () async {
        for (var doc in snapshot.data!.docs) {
          if (selectedMessages.contains(doc.id)) {
            final msg = Messages(
              text: doc["message"],
              time: doc["timestamp"],
              senderEmail: doc["senderEmail"],
              messageId: doc.id,
            );
            final value = ClipboardData(text: msg.text);
            await Clipboard.setData(value);
            myToast("✅ Message Copied");
            setState(() {
              isEditing = !isEditing;
              selectedMessages.clear();
            });
          }
        }
      },
      myIcon: icons.copy,
    );
  }

}
