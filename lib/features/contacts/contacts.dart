import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/TextStyles.dart';
import 'package:whatsappclone/core/MyColors.dart';

import '../testingScreen/Widgets/signoutBtn.dart';
class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 17),
              child: signoutBtn(),
            ),
          ],
          title: Padding(
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
