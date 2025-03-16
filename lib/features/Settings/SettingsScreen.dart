import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsappclone/components/TextStyles.dart';

import 'package:whatsappclone/core/icons.dart';
import 'package:whatsappclone/components/padding.dart';
import 'package:whatsappclone/components/SizedBox.dart';

import '../../components/fontWeightHelper.dart';

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
              children: [
                AppBar(
                  title: Text("Settings", style: Textstyles.settings,),
                ),
                BoxSpacing(myHeight: 20),
                Card(
                  color: Colors.grey.shade100,
                  child: ListTile(
                    title: Text(userName),
                    leading: icons.person,
                  ),
                ),
                BoxSpacing(myHeight: 15,),
                Card(
                  color: Colors.grey.shade100,
                  child: ListTile(
                    title: Text("Delete account"),
                    leading: icons.person,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
