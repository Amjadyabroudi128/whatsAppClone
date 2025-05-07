import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/TextStyles.dart';
import 'package:whatsappclone/components/dividerWidget.dart';
import 'package:whatsappclone/components/kCard.dart';

import '../../../core/icons.dart';

class Starredmessages extends StatefulWidget {
  const Starredmessages({super.key});

  @override
  State<Starredmessages> createState() => _StarredmessagesState();
}

class _StarredmessagesState extends State<Starredmessages> {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Starred messages"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("starred-messages")
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

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (_, index) {
                final data = snapshot.data!.docs[index];
                final message = data["message"] ?? "[No content]";
                final timestamp = data["timestamp"];
                final user = data["senderEmail"];
                DateTime? dateTime;
                if (timestamp is Timestamp) {
                  dateTime = timestamp.toDate();
                } else if (timestamp is DateTime) {
                  dateTime = timestamp;
                } else {
                  dateTime = DateTime.now();
                }
                String formattedTime = DateFormat.Hm().format(dateTime!);
                String day = DateFormat.yMd().format(dateTime);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(user),
                          Spacer(),
                          Text(day)
                        ],
                      ),
                      kCard(
                        color: Colors.grey,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(message),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.star, color: Colors.white,size: 18,),
                                  BoxSpacing(mWidth: 4,),
                                  Text(formattedTime),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      divider()
                    ],
                  ),
                  // child: kCard(
                  //   color: Colors.grey,
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Text(user),
                  //         Text(formattedTime),
                  //         Text(message)
                  //       ],
                  //     ),
                  //   ),
                  // ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
