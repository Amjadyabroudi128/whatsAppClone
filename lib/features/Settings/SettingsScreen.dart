import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsappclone/core/TextStyles.dart';
import 'package:whatsappclone/components/kCard.dart';
import 'package:whatsappclone/components/listTilesOptions.dart';
import 'package:whatsappclone/components/padding.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/features/Settings/Widget/accountFunctions/changeEmail.dart';
import 'package:whatsappclone/features/Settings/Widget/issueReport/issueReport.dart';
import '../../Firebase/FirebaseAuth.dart';
import '../../Firebase/FirebaseCollections.dart';
import '../../core/icons.dart';
import 'Widget/Privacy/Privacy.dart';
import 'Widget/accountFunctions/deleteAccount.dart';
import '../../components/dividerWidget.dart';
import 'Widget/ProfileCard/nameCard.dart';
import 'Widget/accountFunctions/signout.dart';
import 'Widget/favouriteCard/favouriteOptions.dart';
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
  final FirebaseService service = FirebaseService();

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
          final bio = userData?["bio"] ?? "";
          final email = userData?["email"];
          return myPadding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBar(
                    title: const Text("Settings",),
                    centerTitle: false,
                    automaticallyImplyLeading: false,
                  ),
                  const BoxSpacing(myHeight: 20),
                  nameCard(userName: userName, link: link, bio: bio),
                  const BoxSpacing(myHeight: 15,),
                  Text("Account", style: Textstyles.accountStyle,),
                  kCard(
                    child: Column(
                      children: [
                        const signOut(),
                        const divider(),
                        const deleteAccount(),
                        const divider(),
                        ChangeEmail(passwordController: passwordController,
                            email: email,
                            emailController: emailController),
                        const divider(),
                        Options(
                          context: context,
                          label: const Text("Report an issue"),
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => IssueReport(emailController: emailController),
                              ),
                            );
                          },
                          trailing: icons.getIssueIcon(context)
                        ),
                        divider(),
                        Options(
                            context: context,
                            label: const Text("Privacy"),
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const PrivacyScreen()
                                ),
                              );
                            },
                            trailing: icons.arrowForward(context)
                        ),
                      ],
                    ),
                  ),
                  // starCard(user: user),
                  const BoxSpacing(myHeight: 10,),
                  Text("List of Favourite chats",  style: Textstyles.accountStyle,),
                  favouriteCard(user: user),
                  const BoxSpacing(myHeight: 10,),
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
