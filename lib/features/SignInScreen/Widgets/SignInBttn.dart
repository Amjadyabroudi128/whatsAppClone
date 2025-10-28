import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/ElevatedBtn.dart';
import 'package:whatsappclone/components/flutterToast.dart';

import '../../../Firebase/FirebaseAuth.dart';

class siginIn extends StatelessWidget {
  const siginIn({
    super.key,
    required this.firebase,
    required this.myEmail,
    required this.pass,
    required this.user,
    required this.name,
    required this.confirm
  });

  final FirebaseService firebase;
  final TextEditingController myEmail;
  final TextEditingController pass;
  final TextEditingController name;
  final User? user;
  final TextEditingController confirm;

  @override
  Widget build(BuildContext context) {
    return kElevatedBtn(
      onPressed: () async {
        final email = myEmail.text.trim();
        if (email.isEmpty || pass.text.isEmpty || name.text.isEmpty || confirm.text.isEmpty ) {
          myToast("please fill all the fields");
          return;
        }

        if (confirm.text != pass.text) {
          myToast("please confirm password");
          return;
        }
        try {
          await firebase.SigninUser(context, myEmail.text, pass.text, name.text);
          clearController();
        } catch (e) {
          myToast(e.toString());
        }
      },
      child: const Text("Sign in"),
    );
  }

  void clearController() {
    myEmail.clear();
    pass.clear();
    name.clear();
    confirm.clear();
  }
}