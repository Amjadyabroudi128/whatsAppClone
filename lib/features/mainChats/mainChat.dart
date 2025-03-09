import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/TextStyles.dart';
import 'package:whatsappclone/core/MyColors.dart';

import '../privateChatScreen/chatScreen.dart';

class Mainchat extends StatelessWidget {
  final String? name;
  const Mainchat({super.key, this.name});

  @override
  Widget build(BuildContext context) {
    final User currentUser = FirebaseAuth.instance.currentUser!;
    final usersdb = FirebaseFirestore.instance.collection("users");

    return Scaffold(
      appBar: AppBar(
        title: Text("Chats", style: Textstyles.appBar,),
        backgroundColor: myColors.TC,
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder(
        stream: usersdb.snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          var users = snapshot.data!.docs.where((doc) => doc['uid'] != currentUser.uid).toList();
          if (users.isEmpty) return Center(child: Text("No other users found"));
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var userData = users[index];
              bool isOnline = userData['online'] ?? false;
              return ListTile(
                leading: Icon(Icons.account_circle, size: 35,),
                title: Text(userData["email"]),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PrivateChatScreen(
                        receiverId: userData['uid'],
                        receiverEmail: userData['email'],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: (){},
      //   child: icons.add,
      // )
    );
  }
}
