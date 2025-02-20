import 'package:flutter/material.dart';

import '../../../components/scaffoldMessanger.dart';

class signUpBtn extends StatelessWidget {
  const signUpBtn({
    super.key,
    required this.myEmail,
    required this.pass,
  });

  final TextEditingController myEmail;
  final TextEditingController pass;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (){
        myEmail.text.isEmpty ? showSnackbar(context, Text("please provide email")) :
        pass.text.isEmpty ? showSnackbar(context, Text("enter password"))
            : Navigator.of(context).pushNamed("nameScreen");
      },
      child: Text("Sign Up"),
    );
  }
}

