import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/ElevatedBtn.dart';
import 'package:whatsappclone/components/TextButton.dart';
import 'package:whatsappclone/components/TextField.dart';
import 'package:whatsappclone/components/flutterToast.dart';

import '../core/icons.dart';
import 'FirebaseAuth.dart';

class PasswordReset extends StatefulWidget {
  const PasswordReset({Key? key}) : super(key: key);

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  TextEditingController emailController = TextEditingController();
  FirebaseService service  =  FirebaseService();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
        ),
        body: Center(
          child: ListView(
            children: [
              SizedBox(height: 120,),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Text("enter the email associated with your account to reset password",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  ),
                  SizedBox(height: 14,),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: kTextField(hint: "enter email",
                      myController: emailController,
                      icon: icons.emailIcon,
                      ),
                  ),
                  SizedBox(height: 12,),
                  kElevatedBtn(
                    child: Text("Send"),
                    onPressed: () async {
                      await service.resetPass(emailController.text);
                      Navigator.of(context).pushNamed("login");

                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}