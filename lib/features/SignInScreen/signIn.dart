import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/TextStyles.dart';
import 'package:whatsappclone/features/SignUp/signupScreen.dart';

import '../../Firebase/FirebaseAuth.dart';
import '../SignUp/Widgets/emailTextField.dart';
import '../SignUp/Widgets/passField.dart';

class SignInscreen extends StatefulWidget {
  const SignInscreen({super.key});

  @override
  State<SignInscreen> createState() => _SignInscreenState();
}

class _SignInscreenState extends State<SignInscreen> {
  final TextEditingController myEmail = TextEditingController();
  final TextEditingController pass = TextEditingController();
  FirebaseService firebase =  FirebaseService();
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Sign in"),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              emailField(myEmail: myEmail),
              BoxSpacing(myHeight: 20,),
              passField(pass: pass),

              Padding(
                padding: EdgeInsets.only(left: 25, ),
                child: TextButton(onPressed: (){
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => Signupscreen())
                  );
                }, child:
                Text("Not Registered?", style: Textstyles.forgotPass,)
                ),
              ),
              BoxSpacing(myHeight: 19,),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await firebase.SigninUser(myEmail.text, pass.text);
                    print(user?.email);
                    // Navigator.of(context).pushNamed("nameScreen");
                  },
                  child: Text("Sign in"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}




