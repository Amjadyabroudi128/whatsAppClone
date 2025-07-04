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
                    padding: const EdgeInsets.all(10.0),
                    child: Text("Enter your email to reset your password",
                      style: TextStyle(fontSize: 20),),
                  ),
                  SizedBox(height: 14,),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: kTextField(hint: "Your Email",
                      myController: emailController,
                      icon: icons.emailIcon,
                      ),
                  ),
                  SizedBox(height: 12,),
                  kElevatedBtn(
                    child: Text("Send"),
                    onPressed: () async {
                      final newEmail = emailController.text.trim();
                      if(newEmail.isEmpty) {
                        myToast("add email so we can send you a link");
                      } else {
                        await service.resetPass(emailController.text);
                        Navigator.of(context).pushNamed("login");
                      }
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