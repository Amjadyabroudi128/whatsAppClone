import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsappclone/Firebase/FirebaseAuth.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/TextStyles.dart';
import 'package:whatsappclone/components/iconButton.dart';
import 'package:whatsappclone/components/padding.dart';
import 'package:whatsappclone/core/MyColors.dart';
import '../../Firebase/FirebaseCollections.dart';
import '../../core/icons.dart';
import 'Widgets/iconPerson.dart';
import 'Widgets/streamUser.dart';
import 'Widgets/userListTile.dart';
class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  User? user = FirebaseAuth.instance.currentUser;
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseService firebase =  FirebaseService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            kIconButton(
              myIcon: icons.logout,
              onPressed: (){
                firebase.SignOut();
                Navigator.of(context).pushNamed("welcome");
              },
            )
          ],
          title: myPadding(
            padding: const EdgeInsets.only(top: 18),
            child: Text("Chats", style: Textstyles.appBar,),
          ),
          backgroundColor: myColors.TC,
          automaticallyImplyLeading: false,
          centerTitle: false,
        ),
        body: userList(),
    );
  }
}


