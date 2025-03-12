import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/TextStyles.dart';
import 'package:whatsappclone/components/icons.dart';
import 'package:whatsappclone/core/MyColors.dart';

import '../BottomNavBar/BottomNavBar.dart';
import '../testingScreen/Widgets/signoutBtn.dart';

class MainScreen extends StatefulWidget {
  final String? name;
  const MainScreen({super.key, this.name});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          signoutBtn(),
        ],
      ),
      bottomNavigationBar: Bottomnavbar(),
      // body: userList(),
    );
  }
  // Widget userList(DocumentSnapshot document){
  //   return StreamBuilder<QuerySnapshot>(
  //     stream: FirebaseFirestore.instance.collection("users"),
  //     builder: ,
  //   );
  // }
}
