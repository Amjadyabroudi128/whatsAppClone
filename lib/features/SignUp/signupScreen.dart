import 'package:flutter/material.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/padding.dart';
import 'Widgets/emailTextField.dart';
import 'Widgets/haveAnAccount.dart';
import 'Widgets/nameTextfield.dart';
import 'Widgets/passField.dart';
import 'Widgets/signupBtn.dart';

class Signupscreen extends StatefulWidget {
  const Signupscreen({super.key});

  @override
  State<Signupscreen> createState() => _SignupscreenState();
}

class _SignupscreenState extends State<Signupscreen> {
  final TextEditingController myEmail = TextEditingController();
  final TextEditingController pass = TextEditingController();
  final TextEditingController name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Sign up"),
        ),
        body: myPadding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              emailField(myEmail: myEmail),
              const BoxSpacing(myHeight: 20,),
              nameField(name: name),
              const BoxSpacing(myHeight: 20,),
              passField(pass: pass),
              const myPadding(
                padding: EdgeInsets.only(left: 25, ),
                child: haveAnAccount(),
              ),

              const BoxSpacing(myHeight: 19,),
              Center(
                child: signUpBtn(myEmail: myEmail, pass: pass, name: name,),
              )
            ],
          ),
        ),
      ),
    );
  }
}






