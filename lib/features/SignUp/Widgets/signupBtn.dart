import 'package:flutter/material.dart';

class signupBtn extends StatelessWidget {
  const signupBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (){
        Navigator.of(context).pushNamed("nameScreen");
      },
      child: Text("Sign Up"),
    );
  }
}
