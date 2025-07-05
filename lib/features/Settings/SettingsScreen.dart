


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsappclone/components/btmSheet.dart';
import 'package:whatsappclone/core/TextStyles.dart';
import 'package:whatsappclone/components/kCard.dart';
import 'package:whatsappclone/components/listTilesOptions.dart';
import 'package:whatsappclone/components/padding.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/features/Settings/Widget/ProfileCard/editEmail.dart';
import 'package:whatsappclone/features/Settings/Widget/starCard/allStars.dart';
import 'package:whatsappclone/utils/pickImage.dart';
import '../../Firebase/FirebaseCollections.dart';
import '../../core/icons.dart';
import '../chatScreen/userDetails/StarredMessages.dart';
import 'Widget/accountFunctions/deleteAccount.dart';
import '../../components/dividerWidget.dart';
import 'Widget/ProfileCard/nameCard.dart';
import 'Widget/accountFunctions/signout.dart';
import 'Widget/starCard/starCard.dart';
import 'Widget/themeCard/themeCard.dart';

class SettingScreen extends StatefulWidget {
  final void Function(ThemeData, ThemeMode)? onThemeChange;
  const SettingScreen({super.key, this.onThemeChange,});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: user == null
          ? const Center(child: Text("No user logged in"))
          : FutureBuilder<DocumentSnapshot>(
        future: userC
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
          final link = userData?['link'] ?? 'No name found';
          final imageUrl = userData?['image'] ?? '';
          final bio = userData?["bio"] ?? "";
          final email = userData?["email"];
          return myPadding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBar(
                    title: Text("Settings",),
                    centerTitle: false,
                    automaticallyImplyLeading: false,
                  ),
                  BoxSpacing(myHeight: 20),
                  nameCard(userName: userName, link: link, bio: bio),
                  BoxSpacing(myHeight: 15,),
                  Text("Account", style: Textstyles.accountStyle,),
                  kCard(
                    child: Column(
                      children: [
                        signOut(),
                        divider(),
                        deleteAccount(),
                        divider(),
                        Options(
                          context: context,
                          label: Text("Change email"),
                          trailing: icons.emailIcon,
                          onTap: ()async {
                            await btmSheet(
                              context: context,
                                isScrollControlled: true,
                              builder: (context) {
                                return Editemail(email: email, emailController: emailController,
                                  passwordController: passwordController,);
                              }
                            );
                          }
                        )
                      ],
                    ),
                  ),
                  starCard(user: user),
                  BoxSpacing(myHeight: 10,),
                  Text("App Theme", style: Textstyles.themeStyle),
                  themeCard(mounted: mounted, widget: widget)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
