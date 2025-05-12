import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/SizedBox.dart';

import '../../../core/icons.dart';

class myMedia extends StatelessWidget {
  const myMedia({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Media"),
        centerTitle: true,
        actions: [

        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("messages").where("image", isNotEqualTo: null).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());

          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icons.noImages,
                  BoxSpacing(myHeight: 10,),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      "no Media",
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  BoxSpacing(myHeight: 9,),
                  Text('Tap "+" in a Chat to share photos and videos\n with this Contact ',
                    textAlign: TextAlign.center, style: TextStyle(fontSize: 17, color: Colors.grey), )
                ],
              ),
            );
          }
          return Text("Good morning ");
        },
      )
    );
  }
}
