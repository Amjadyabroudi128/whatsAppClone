import 'package:flutter/material.dart';
import 'package:whatsappclone/Firebase/FirebaseAuth.dart';
import 'package:whatsappclone/components/ElevatedBtn.dart';
import 'package:whatsappclone/components/flutterToast.dart';

class signUpBtn extends StatelessWidget {
  const signUpBtn({
    super.key,
    required this.myEmail,
    required this.pass, required this.name,
  });

  final TextEditingController myEmail;
  final TextEditingController pass;
  final TextEditingController name;

  @override
  Widget build(BuildContext context) {
    FirebaseService firebase =  FirebaseService();
    return kElevatedBtn(
      onPressed: () async {
        if(myEmail.text.isEmpty || pass.text.isEmpty) {
          myToast("please fill all the fields");
          return;
        }
          await firebase.createEmailPassword(context, myEmail.text, pass.text,name.text );
      },
      child: Text("Sign Up"),
    );
  }
}

