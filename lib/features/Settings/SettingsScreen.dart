import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsappclone/components/TextStyles.dart';
import 'package:whatsappclone/components/iconButton.dart';
import 'package:whatsappclone/components/popUpMenu.dart';
import 'package:whatsappclone/core/MyColors.dart';
import 'package:whatsappclone/components/padding.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/core/appTheme.dart';
import 'package:whatsappclone/core/icons.dart';
import 'package:whatsappclone/enums/enums.dart';
import 'Widget/deleteAccount.dart';
import 'Widget/nameCard.dart';
import 'Widget/signout.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key,});

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
                BoxSpacing(myHeight: 10,),
                Text("App Theme", style: TextStyle(color: Colors.grey[500]),),
                Card(
                  child: ListTile(
                    title: Text("Theme"),
                    trailing: MyPopUpMenu(
                      icon: icons.arrowForward,
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem<myPop>(
                            value: myPop.off,
                            child: Text(("Off")),
                          ),
                          PopupMenuItem<myPop>(
                            value: myPop.darkTheme ,
                            child: Text(("Dark Theme")),
                          ),
                          PopupMenuItem<myPop>(
                            value: myPop.system,
                            child: Text(("System theme")),
                          ),
                        ];
                      },
                      onSelected: (selectedValue){
                        if (selectedValue == myPop.darkTheme) {
                          myTheme.darkTheme;
                        } else if (selectedValue == myPop.off) {
                          myTheme.appTheme;
                        }
                      },
                    )
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



