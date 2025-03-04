import 'package:flutter/material.dart';
import 'package:whatsappclone/Firebase/FirebaseAuth.dart';
import 'package:whatsappclone/components/ElevatedBtn.dart';

class signUpBtn extends StatelessWidget {
  const signUpBtn({
    super.key,
    required this.myEmail,
    required this.pass,
  });

  final TextEditingController myEmail;
  final TextEditingController pass;

  @override
  Widget build(BuildContext context) {
    FirebaseService firebase =  FirebaseService();
    return kElevatedBtn(
      onPressed: () async {
        await firebase.createEmailPassword( context ,myEmail.text, pass.text);
      },
      child: Text("Sign Up"),
    );
  }
}

