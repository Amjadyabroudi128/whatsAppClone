import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/features/name%20screen/Widgets/nameTField.dart';
import '../../Firebase/FirebaseAuth.dart';
import '../SignUp/Widgets/emailTextField.dart';
import '../SignUp/Widgets/passField.dart';
import 'Widgets/SignInBttn.dart';
import 'Widgets/notRegistered.dart';

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
                child: NotRegisterd(),
              ),
              BoxSpacing(myHeight: 19,),
              Center(
                child: siginIn(firebase: firebase, myEmail: myEmail, pass: pass, user: user,),
              )
            ],
          ),
        ),
      ),
    );
  }
}






