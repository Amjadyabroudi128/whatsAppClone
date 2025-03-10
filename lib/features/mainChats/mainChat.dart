import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/TextStyles.dart';
import 'package:whatsappclone/components/icons.dart';
import 'package:whatsappclone/core/MyColors.dart';

import '../testingScreen/Widgets/signoutBtn.dart';

class Mainchat extends StatefulWidget {
  final String? name;
  const Mainchat({super.key, this.name});

  @override
  State<Mainchat> createState() => _MainchatState();
}

class _MainchatState extends State<Mainchat> {
  User? user = FirebaseAuth.instance.currentUser;
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          signoutBtn(),
        ],
        title: Text("Chats", style: Textstyles.appBar,),
        backgroundColor: myColors.TC,
        automaticallyImplyLeading: false,
      ),
      // body: userList(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: icons.add,
      )
    );
  }
  // Widget userList(DocumentSnapshot document){
  //   return StreamBuilder<QuerySnapshot>(
  //     stream: FirebaseFirestore.instance.collection("users"),
  //     builder: ,
  //   );
  // }
}
