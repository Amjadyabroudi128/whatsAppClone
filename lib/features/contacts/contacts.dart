import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/TextStyles.dart';
import 'package:whatsappclone/components/padding.dart';
import 'package:whatsappclone/core/MyColors.dart';

import '../chatScreen/chatScreen.dart';
import '../testingScreen/Widgets/signoutBtn.dart';
import 'Widgets/iconPerson.dart';
import 'Widgets/userListTile.dart';
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
        body: userList(),
    );
  }
  Widget userList(){
    final currentUserId = user?.uid ?? '';
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("users").snapshots(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(),);
        } if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No users found"));
        }
        final users = snapshot.data!.docs.where((doc) => doc.id != currentUserId).toList();
        if (users.isEmpty) {
          return Center(child: Text("No other users available"));
        }
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final userDoc = users[index];

            return myPadding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      person(),
                      BoxSpacing(mWidth: 10),
                      Expanded(
                        child: listTile(userDoc: userDoc),
                      ),
                    ],
                  ),
                  Divider(
                    indent: 30,
                  ),
                ],
              ),
            );
          },
        );
      },
    );

  }
}


