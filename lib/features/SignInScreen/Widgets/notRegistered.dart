import 'package:flutter/material.dart';
import '../../../components/TextButton.dart';
import '../../../core/TextStyles.dart';
import '../../SignUp/signupScreen.dart';

class NotRegistered extends StatelessWidget {
  const NotRegistered({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return kTextButton(
        style: TextButton.styleFrom(
          textStyle: Textstyles.haveAccount,
          foregroundColor: Colors.blue,
        ),
        onPressed: (){
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const Signupscreen())
          );
        }, child:
    const Text("Sign up",)
    );
  }
}
