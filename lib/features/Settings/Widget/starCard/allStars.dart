import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whatsappclone/components/imageNetworkComponent.dart';
import 'package:whatsappclone/features/chatScreen/chatScreen.dart';

import '../../../../Firebase/FirebaseAuth.dart';
import '../../../../components/SizedBox.dart';
import '../../../../components/TextButton.dart';
import '../../../../core/TextStyles.dart';
import '../../../../components/dividerWidget.dart';
import '../../../../components/flutterToast.dart';
import '../../../../components/iconButton.dart';
import '../../../../components/kCard.dart';
import '../../../../core/MyColors.dart';
import '../../../../core/icons.dart';
import '../../../../messageClass/messageClass.dart';

class allStarred extends StatefulWidget {
  const allStarred({super.key, String? receiverId});

  @override
  State<allStarred> createState() => _allStarredState();
}

class _allStarredState extends State<allStarred> {
  final auth = FirebaseAuth.instance;
  FirebaseService service = FirebaseService();
  bool isEditing = false;
  Set<String> selectedMessages = {};
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
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("starred-messages")
              .doc(auth.currentUser!.email)
              .collection("messages")
              .orderBy("timestamp", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
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
                      senderId: data["senderId"],
                      receiverId: data["receiverId"],
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
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                msg.senderEmail == auth.currentUser!.email ? "You" : msg.senderEmail!,
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
                                    activeColor: myColors.starColor,
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
                              Flexible(
                                child: kCard(
                                  color: msg.senderEmail == auth.currentUser!.email ?
                                  myColors.starColor : myColors.familyText,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        msg.image != null && msg.image!.isNotEmpty
                                            ? kimageNet(src: msg.image!)
                                            : Text(msg.text, overflow: TextOverflow.ellipsis, maxLines: msg.text.length,),
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
                              ),
                              Spacer(),
                              kIconButton(
                                onPressed: () async {
                                  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
                                  final isSentByMe = msg.senderId == currentUserId;
                                  final receiverId = isSentByMe ? msg.receiverId : msg.senderId;
                                  final receiverSnapshot = await FirebaseFirestore.instance.collection('users').doc(receiverId).get();
                                  if (receiverSnapshot.exists) {
                                    final receiverName = receiverSnapshot.data()?['name'] ?? 'Unknown';
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Testname(
                                          receiverId: receiverId!,
                                          receiverName: receiverName,
                                          msg: msg.messageId,
                                        ),
                                      ),
                                    );
                                  } else {
                                    // Handle the case where receiver data is not found
                                    myToast("Receiver data not found.");
                                  }
                                },
                                myIcon: icons.arrowForward,
                              )

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
                        // copyIcon(snapshot),
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
                                  senderId: doc["senderId"],
                                  receiverId: doc["receiverId"],
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
                                  receiverId: doc["receiverId"],
                                  senderEmail: doc["senderEmail"],
                                  senderId: doc["senderId"],
                                );
                                await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text("You are about to delete a message"),
                                      content: Text("Are you sure? "),
                                      actions: [
                                        kTextButton(
                                          onPressed: () =>  Navigator.pop(context),
                                          child: Text("Cancel"),
                                        ),
                                        kTextButton(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            await service.Deletemessage(msg.senderId ?? "", msg.receiverId ?? "", msg.messageId ?? "");
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
}
