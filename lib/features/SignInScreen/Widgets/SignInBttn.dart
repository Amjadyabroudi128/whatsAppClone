import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../Firebase/FirebaseAuth.dart';

class siginIn extends StatelessWidget {
  const siginIn({
    super.key,
    required this.firebase,
    required this.myEmail,
    required this.pass,
    required this.user,
  });

  final FirebaseService firebase;
  final TextEditingController myEmail;
  final TextEditingController pass;
  final User? user;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await firebase.SigninUser(myEmail.text, pass.text);
        print(user?.email);
        // Navigator.of(context).pushNamed("nameScreen");
      },
      child: Text("Sign in"),
    );
  }
}
