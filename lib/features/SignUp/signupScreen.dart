import 'package:flutter/material.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/scaffoldMessanger.dart';
import 'Widgets/emailTextField.dart';
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
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Sign up"),
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
                child: TextButton(onPressed: (){}, child: Text("Forgot Password ?", style: TextStyle(color: Colors.blueGrey),)),
              ),
              BoxSpacing(myHeight: 19,),
              Center(
                child: signUpBtn(myEmail: myEmail, pass: pass),
              )
            ],
          ),
        ),
      ),
    );
  }
}




