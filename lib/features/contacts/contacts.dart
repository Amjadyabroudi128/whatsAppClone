import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsappclone/components/TextStyles.dart';
import 'package:whatsappclone/components/padding.dart';
import 'package:whatsappclone/core/MyColors.dart';

import '../testingScreen/Widgets/signoutBtn.dart';
class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  User? user = FirebaseAuth.instance.currentUser;
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            myPadding(
              padding: const EdgeInsets.only(top: 17),
              child: signoutBtn(),
            ),
          ],
          title: myPadding(
            padding: const EdgeInsets.only(top: 18),
            child: Text("Chats", style: Textstyles.appBar,),
          ),
          backgroundColor: myColors.TC,
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Text("SALAM"),
        ),
    );
  }
}
