import 'package:flutter/material.dart';
import 'package:whatsappclone/components/ElevatedBtn.dart';
import 'package:whatsappclone/components/SizedBox.dart';
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
    OutlineInputBorder enabled = OutlineInputBorder(borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
            color: Colors.transparent
        )
    );
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text("Enter your email to reset your password",
                      style: TextStyle(fontSize: 20),),
                  ),
                  const BoxSpacing(myHeight: 14,),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: kTextField(
                      hint: "Your Email",
                      enable: enabled,
                      filled: true,
                      myController: emailController,
                      icon: icons.emailIcon(context),
                      ),
                  ),
                  const BoxSpacing(myHeight: 12,),
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