import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsappclone/components/TextStyles.dart';
import 'package:whatsappclone/components/padding.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'Widget/deleteAccount.dart';
import 'Widget/dividerWidget.dart';
import 'Widget/nameCard.dart';
import 'Widget/signout.dart';
import 'Widget/themeCard.dart';

class SettingScreen extends StatefulWidget {
  final Function(ThemeData)? onThemeChange;
  const SettingScreen({super.key, this.onThemeChange,});

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
                Text("Account", style: Textstyles.accountStyle,),
                Card(
                  child: Column(
                    children: [
                      signOut(),
                      divider(),
                      deleteAccount(),
                    ],
                  ),
                ),
                BoxSpacing(myHeight: 10,),
                Text("App Theme", style: Textstyles.themeStyle),
                themeCard(mounted: mounted, widget: widget)
              ],
            ),
          );
        },
      ),
    );
  }
}




