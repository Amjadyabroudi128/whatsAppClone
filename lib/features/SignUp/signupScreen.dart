import 'package:flutter/material.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/TextField.dart';
import 'package:whatsappclone/components/padding.dart';
import 'package:whatsappclone/core/MyColors.dart';
import '../../core/icons.dart';
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
          title: Text("Sign up"),
        ),
        body: myPadding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              emailField(myEmail: myEmail),
              BoxSpacing(myHeight: 20,),
              nameField(name: name),
              BoxSpacing(myHeight: 20,),
              passField(pass: pass),
              myPadding(
                padding: EdgeInsets.only(left: 25, ),
                child: haveAnAccount(),
              ),

              BoxSpacing(myHeight: 19,),
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






