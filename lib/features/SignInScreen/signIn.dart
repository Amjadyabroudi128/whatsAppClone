import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/TextButton.dart';
import 'package:whatsappclone/components/padding.dart';
import 'package:whatsappclone/core/TextStyles.dart';
import '../../Firebase/FirebaseAuth.dart';
import '../../components/TextField.dart';
import '../../core/icons.dart';
import '../SignUp/Widgets/emailTextField.dart';
import '../SignUp/Widgets/nameTextfield.dart';
import '../SignUp/Widgets/passField.dart';
import 'Widgets/SignInBttn.dart';
import 'Widgets/notRegistered.dart';

final _formKey = GlobalKey<FormState>();

class SignInscreen extends StatefulWidget {
  const SignInscreen({super.key});

  @override
  State<SignInscreen> createState() => _SignInscreenState();
}

class _SignInscreenState extends State<SignInscreen> {
  final TextEditingController myEmail = TextEditingController();
  final TextEditingController pass = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController confirm = TextEditingController();

  FirebaseService firebase = FirebaseService();
  User? user = FirebaseAuth.instance.currentUser;

  bool hasMatched() {
    return pass.text == confirm.text && pass.text.isNotEmpty;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pass.addListener(() {
      setState(() {});
    });
    confirm.addListener(() {
      setState(() {});
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pass;
    confirm;
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Sign in"),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: myPadding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    emailField(myEmail: myEmail),
                    const BoxSpacing(myHeight: 20),
                    nameField(name: name),
                    const BoxSpacing(myHeight: 20),
                    passField(pass: pass),
                    const BoxSpacing(myHeight: 20),
                    kTextField(
                      textInputAction: TextInputAction.done,
                      maxLines: 1,
                      label: const Text("Confirm pass"),
                      myController: confirm,
                      myIcon: icons.passIcon,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          "Password match: ${hasMatched() ? "Yes" : "No"}",
                          style: TextStyle(
                            color: hasMatched() ? Colors.green : Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 1, top: 1),
                      child: kTextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed("passReset");
                        },
                        child: const Text("Forgotten Password?"),
                      ),
                    ),
                    const BoxSpacing(myHeight: 19),
                    Center(
                      child: siginIn(
                        firebase: firebase,
                        myEmail: myEmail,
                        pass: pass,
                        user: user,
                        name: name,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Not registered?", style: Textstyles.notReg),
                        const NotRegistered()
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
