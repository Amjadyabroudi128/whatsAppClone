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

class MyMedia extends StatelessWidget {
  const MyMedia({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Media"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("media")
            .doc(currentUserId)
            .collection("messages")
            .where("image", isNotEqualTo: null)
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
                  senderEmail: data["senderEmail"]
                );
                final dateTime = (msg.time != null) ? msg.time!.toDate() : DateTime.now();
                final formattedTime = DateFormat.Hm().format(dateTime);
                final day = DateFormat.yMd().format(dateTime);
                return Column(
                  children: [
                    Text(day, style: const TextStyle(fontSize: 12)),
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => Imagescreen(image: msg.image, date: day, senderName: msg.senderEmail, time: formattedTime,),
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

