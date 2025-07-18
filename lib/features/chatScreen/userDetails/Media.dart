import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/icons.dart';
import '../../../messageClass/messageClass.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/imageNetworkComponent.dart';

import 'Widgets/noMediaText.dart';
import 'imageScreen.dart';

class MyMedia extends StatefulWidget {
 final String? receiverId;
  const MyMedia({super.key,this.receiverId});

  @override
  State<MyMedia> createState() => _MyMediaState();
}

class _MyMediaState extends State<MyMedia> {
  User? user = FirebaseAuth.instance.currentUser;
  final auth = FirebaseAuth.instance;
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
        title: const Text("Media"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("chat_rooms")
            .doc(chatRoomId)
            .collection("messages")
            .where("image", isGreaterThan: "")
            .orderBy("image")
            .orderBy("timestamp", descending: true)
            .snapshots(),

        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icons.noImages,
                  BoxSpacing(myHeight: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      "No Media",
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  BoxSpacing(myHeight: 9),
                  noMedia(),
                ],
              ),
            );
          }

          final mediaDocs = snapshot.data!.docs;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
              ),
              itemCount: mediaDocs.length,
              itemBuilder: (_, index) {
                final data = mediaDocs[index];
                final msg = Messages(
                  text: data["message"],
                  messageId: data["messageId"],
                  image: data["image"],
                  senderId: data["senderId"],
                  receiverId: data["receiverId"],
                  senderEmail: data["senderEmail"],
                );
                if (msg.image == null) return const SizedBox.shrink();
                final dateTime = (msg.time != null) ? msg.time!.toDate() : DateTime.now();
                final formattedTime = DateFormat.Hm().format(dateTime);
                final day = DateFormat.yMd().format(dateTime);
                return Column(
                  children: [
                    Text(day, style: const TextStyle(fontSize: 12)),
                    Text(
                      msg.senderEmail == auth.currentUser!.email ? "You" : msg.senderEmail ?? "",
                      style: TextStyle(fontSize: 15),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => Imagescreen(
                                image: msg.image,
                                date: day,
                                senderName: msg.senderEmail,
                                time: formattedTime,
                                messageId: msg.messageId,
                                receiverId: msg.receiverId,
                                senderId: msg.senderId,
                                senderEmail: msg.senderEmail,
                                receiverEmail: msg.receiverEmail,
                              ),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: msg.image != null
                              ? kimageNet(src: msg.image!)
                              :  icons.supportedImage
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

