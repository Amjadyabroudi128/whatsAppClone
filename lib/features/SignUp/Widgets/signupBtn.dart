import 'package:flutter/material.dart';
import 'package:whatsappclone/Firebase/FirebaseAuth.dart';

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
    return ElevatedButton(
      onPressed: () async {
        await firebase.createEmailPassword(myEmail.text, pass.text);
        Navigator.of(context).pushNamed("nameScreen");
      },
      child: Text("Sign Up"),
    );
  }
}

