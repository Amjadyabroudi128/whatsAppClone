import 'package:flutter/material.dart';
import 'package:whatsappclone/core/MyColors.dart';
import 'package:whatsappclone/features/SignUp/passField.dart';

import 'emailTextField.dart';

class Signupscreen extends StatefulWidget {
  const Signupscreen({super.key});

  @override
  State<Signupscreen> createState() => _SignupscreenState();
}

class _SignupscreenState extends State<Signupscreen> {
  final TextEditingController myEmail = TextEditingController();
  final TextEditingController pass = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign up"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            emailField(myEmail: myEmail),
            SizedBox(height: 10,),
            passField(pass: pass),
          ],
        ),
      ),
    );
  }
}


