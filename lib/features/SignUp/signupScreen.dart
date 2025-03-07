import 'package:flutter/material.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/TextButton.dart';
import 'package:whatsappclone/components/TextStyles.dart';
import 'package:whatsappclone/components/scaffoldMessanger.dart';
import 'package:whatsappclone/features/SignInScreen/signIn.dart';
import '../name screen/Widgets/nameTField.dart';
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
                child: kTextButton(onPressed: (){
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => SignInscreen())
                  );
                  },
                    child: Text("have an account?", style: Textstyles.haveAccount,)
                ),
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




