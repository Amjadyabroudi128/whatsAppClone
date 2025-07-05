import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/TextButton.dart';
import 'package:whatsappclone/components/fSizedBox.dart';
import '../../../../Firebase/FirebaseAuth.dart';
import '../../../../components/TextField.dart';
import '../../../../components/flutterToast.dart';
import '../../../../core/icons.dart';

class Editemail extends StatelessWidget {
  final String email;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const Editemail({
    super.key,
    required this.email,
    required this.emailController, 
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    FirebaseService service = FirebaseService();
    OutlineInputBorder enabled = OutlineInputBorder(borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
            color: Colors.transparent
        )
    );
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: fSizedBox(
        heightFactor: 0.94,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Edit your email"),
            actions: [
              kTextButton(
                onPressed: () async {
                  final newEmail = emailController.text.trim();
                  if (newEmail.isEmpty) {
                    myToast("Your Email is empty");
                  } else if (newEmail == email) {
                    myToast("Change something");
                  } else {
                    await showDialog(
                      context: context,
                      builder: (context){
                        return AlertDialog(
                            title: Text("Re-authenticate"),
                            content: TextField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(labelText: "Enter your password"),
                            ),
                            actions: [
                              kTextButton(
                                onPressed: (){
                                  FocusScope.of(context).unfocus();
                                },
                                child: Text("Cancel"),
                              ),
                              kTextButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  if(passwordController.text.isEmpty) {
                                    myToast("add your password");
                                  } else {
                                    await service.authenticate(email, newEmail, passwordController.text.trim());
                                  }
                                },
                                child: Text("Confirm"),
                              ),
                            ]
                        );
                      }
                    );
                    emailController.clear();
                    passwordController.clear();
                  }
                },
                child: Text("Save"),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("This is your Current Email"),
                BoxSpacing(myHeight: 10),
                kTextField(
                  filled: true,
                  maxLines: 1,
                  hint: email,
                  enabled: false,
                ),
                BoxSpacing(myHeight: 10),
                Text("Change email"),
                BoxSpacing(myHeight: 10),
                kTextField(
                  icon: icons.emailIcon,
                  enable: enabled,
                  filled: true,
                  maxLines: 1,
                  hint: "e.g John@gmail.com",
                  myController: emailController,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Future<void> reauthenticateAndUpdateEmail(
  //     BuildContext context,
  //     String uid,
  //     String currentEmail,
  //     String newEmail,
  //     ) async {
  //   final user = FirebaseAuth.instance.currentUser!;
  //
  //   String? password = await showDialog<String>(
  //     context: context,
  //     builder: (context) {
  //       final passController = TextEditingController();
  //       return AlertDialog(
  //         title: Text("Re-authenticate"),
  //         content: TextField(
  //           controller: passController,
  //           obscureText: true,
  //           decoration: InputDecoration(labelText: "Enter your password"),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(null),
  //             child: Text("Cancel"),
  //           ),
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(passController.text),
  //             child: Text("Confirm"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  //
  //   if (password == null || password.isEmpty) {
  //     myToast("Re-authentication cancelled");
  //     return;
  //   }
  //
  //   try {
  //     final cred = EmailAuthProvider.credential(email: currentEmail, password: password);
  //     await user.reauthenticateWithCredential(cred);
  //
  //     await FirebaseFirestore.instance.collection("users").doc(uid).update({
  //       "email": newEmail,
  //     });
  //
  //     await user.verifyBeforeUpdateEmail(newEmail);
  //     myToast("Email update link sent to new address");
  //   } on FirebaseAuthException catch (e) {
  //     myToast("Error: ${e.message}");
  //   }
  // }
}
