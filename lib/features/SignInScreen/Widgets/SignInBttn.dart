import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/ElevatedBtn.dart';
import 'package:whatsappclone/components/flutterToast.dart';
import 'package:whatsappclone/components/scaffoldMessanger.dart';

import '../../../Firebase/FirebaseAuth.dart';

class siginIn extends StatelessWidget {
  const siginIn({
    super.key,
    required this.firebase,
    required this.myEmail,
    required this.pass,
    required this.user,
    required this.name
  });

  final FirebaseService firebase;
  final TextEditingController myEmail;
  final TextEditingController pass;
  final TextEditingController name;
  final User? user;

  @override
  Widget build(BuildContext context) {
    return kElevatedBtn(
      onPressed: () async {
        if (myEmail.text.isEmpty || pass.text.isEmpty || name.text.isEmpty) {
          myToast("please fill all the fields");
          return;
        }
        await firebase.SigninUser(context,myEmail.text, pass.text, name.text);
      },
      child: Text("Sign in"),
    );
  }
}
