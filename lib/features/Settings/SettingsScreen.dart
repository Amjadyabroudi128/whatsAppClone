import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsappclone/components/TextStyles.dart';
import 'package:whatsappclone/components/iconButton.dart';
import 'package:whatsappclone/core/MyColors.dart';
import 'package:whatsappclone/components/padding.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'Widget/deleteAccount.dart';
import 'Widget/nameCard.dart';
import 'Widget/signout.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: user == null
          ? const Center(child: Text("No user logged in"))
          : FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection("users")
            .doc(user!.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("User data not found"));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>?;

          final userName = userData?['name'] ?? 'No name found';

          return myPadding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBar(
                  title: Text("Settings", style: Textstyles.settings,),
                ),
                BoxSpacing(myHeight: 20),
                nameCard(userName: userName),
                BoxSpacing(myHeight: 15,),
                Text("Account", style: TextStyle(fontSize: 17, color: Colors.grey),),
                Card(
                  color: myColors.CardColor,
                  child: Column(
                    children: [
                      signOut(),
                      Divider(
                        indent: 19,
                        endIndent: 10,
                        color: Colors.grey.shade400,
                      ),
                      deleteAccount(),
                    ],
                  ),
                ),
                Text("App Theme", style: TextStyle(color: Colors.grey[500]),),
                Card(
                  color: myColors.CardColor,
                  child: ListTile(
                    title: Text("Theme"),
                    trailing: IconButton(
                      onPressed: (){},
                      icon: Icon(Icons.arrow_forward_ios, size: 15,),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}



