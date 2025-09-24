import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:whatsappclone/Firebase/FirebaseAuth.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/core/TextStyles.dart';
import 'package:whatsappclone/components/dividerWidget.dart';
import 'package:whatsappclone/components/iconButton.dart';
import 'package:whatsappclone/components/kCard.dart';
import 'package:whatsappclone/features/chatScreen/Model/MessageModel.dart';
import '../../../components/TextButton.dart';
import '../../../components/flutterToast.dart';
import '../../../core/MyColors.dart';
import '../../../core/icons.dart';

class Starredmessages extends StatefulWidget {
  final String? receiverId;
  final String? chatRoomId;
  const Starredmessages({super.key, this.receiverId, this.chatRoomId});

  @override
  State<Starredmessages> createState() => _StarredmessagesState();
}

class _StarredmessagesState extends State<Starredmessages> {
  final auth = FirebaseAuth.instance;
  FirebaseService service = FirebaseService();
  bool isEditing = false;
  Set<String> selectedMessages = {};
  User? user = FirebaseAuth.instance.currentUser;

  String getChatRoomId(String id1, String id2) {
    List<String> ids = [id1, id2];
    ids.sort();
    return ids.join("_");
  }

  @override
  Widget build(BuildContext context) {
    String chatRoomId = getChatRoomId(user!.uid, widget.receiverId!);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Starred messages"),
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
          // FIXED: First get user's starred messages, then filter for current chat room
          stream: FirebaseFirestore.instance
              .collection("starred-messages")
              .doc(auth.currentUser!.email!)
              .collection("messages")
              .orderBy("timestamp", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            // Filter for current chat room only
            final currentChatMessages = snapshot.data!.docs.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              List<String> ids = [data['senderId'], data['receiverId']];
              ids.sort();
              String docChatRoomID = ids.join("_");
              return docChatRoomID == chatRoomId;
            }).toList();

            if (currentChatMessages.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    icons.noStar,
                    const BoxSpacing(myHeight: 9),
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

            // No need to filter anymore since query is already specific to this chat

            return Stack(
                children: [
                  ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (_, index) {
                      final data = snapshot.data!.docs[index];
                      final msg = Messages(
                        text: data["message"],
                        time: data["timestamp"],
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
                              children: [
                                Text(
                                  msg.senderEmail == auth.currentUser!.email ? "You" : msg.senderEmail!,
                                  style: const TextStyle(fontSize: 15),
                                ),
                                const Spacer(),
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
                                      activeColor: MyColors.starColor,
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
                                    MyColors.starColor : MyColors.familyText,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          msg.image != null && msg.image!.isNotEmpty
                                              ? Image.network(
                                            msg.image!,
                                            height: 150,
                                            width: 150,
                                            fit: BoxFit.cover,
                                          )
                                              : Text(msg.text, maxLines: msg.text.length,
                                            overflow: TextOverflow.ellipsis,),

                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              icons.wStar,
                                              const BoxSpacing(mWidth: 4,),
                                              Text(formattedTime),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const divider(),
                          ],
                        ),
                      );
                    },
                  ),
                  isEditing && selectedMessages.isNotEmpty ?
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: selectedMessages.length > 1 ? MediaQuery.of(context).size.width * 0.3 : 0,
                    child: Row(
                      mainAxisAlignment: selectedMessages.length > 1 ?
                      MainAxisAlignment.spaceAround : MainAxisAlignment.spaceEvenly,
                      children: [
                        selectedMessages.length > 1 ? const SizedBox.shrink() : copyIcon(currentChatMessages),
                        kIconButton(
                          onPressed: () async {
                            myToast("⭐ Message unstarred ");
                            for (var doc in currentChatMessages) {
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
                          myIcon: icons.slash(context),
                        ),
                        if(selectedMessages.length == 1 ?
                        // For single message: show if user is receiver OR message sender
                        (user!.uid == widget.receiverId ||
                            selectedMessages.any((messageId) =>
                                currentChatMessages.any((doc) =>
                                doc.id == messageId && doc["senderId"] == user!.uid))) :
                        // For multiple messages: show only if ALL selected messages belong to current user
                        selectedMessages.every((messageId) =>
                            currentChatMessages.any((doc) =>
                            doc.id == messageId && doc["senderId"] == user!.uid)))
                          kIconButton(
                            onPressed: () async {
                              for( var doc in currentChatMessages ) {
                                if (selectedMessages.contains(doc.id)) {
                                  final msg = Messages(
                                    messageId: doc.id,
                                    text: doc["message"],
                                    time: doc["timestamp"],
                                    receiverId: doc["receiverId"],
                                    senderEmail: doc["senderEmail"],
                                    senderId: doc["senderId"],
                                  );
                                  await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: selectedMessages.length > 1 ?
                                        Text("You are about to Delete ${selectedMessages.length} Messages") :
                                        Text("You are about to Delete ${msg.text}"),
                                        content: const Text("Are you sure? "),
                                        actions: [
                                          kTextButton(
                                            onPressed: () =>  Navigator.pop(context),
                                            child: const Text("Cancel"),
                                          ),
                                          kTextButton(
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              myToast("Selected messages deleted");
                                              await service.deleteSelectedMessages(
                                                  senderId: msg.senderId ?? "",
                                                  receiverId: msg.receiverId ?? "",
                                                  messageIds: selectedMessages);
                                              await service.deleteStar(msg);
                                              Navigator.pop(context);
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
                  ) : const SizedBox.shrink()
                ]
            );
          },
        ),
      ),
    );
  }

  kIconButton copyIcon(List<QueryDocumentSnapshot> docs) {
    return kIconButton(
      onPressed: () async {
        for (var doc in docs) {
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
      myIcon: const Icon(Icons.copy),
    );
  }
}