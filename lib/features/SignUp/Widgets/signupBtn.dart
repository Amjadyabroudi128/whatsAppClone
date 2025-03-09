import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/Firebase/FirebaseAuth.dart';
import 'package:whatsappclone/components/ElevatedBtn.dart';
import 'package:whatsappclone/components/flutterToast.dart';

class signUpBtn extends StatelessWidget {
  const signUpBtn({
    super.key,
    required this.myEmail,
    required this.firebase,
    required this.pass,
  });

  final TextEditingController myEmail;
  final TextEditingController pass;
  final FirebaseService firebase;
  @override
  Widget build(BuildContext context) {
    return kElevatedBtn(
      onPressed: () async {
        if(myEmail.text.isEmpty || pass.text.isEmpty) {
          myToast("please fill all the fields");
          firebase.createEmailPassword(context, myEmail.text, pass.text)
        }
      },
      child: Text("Sign Up"),
    );
  }
}

