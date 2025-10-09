import 'package:flutter/material.dart';

import '../../../components/TextButton.dart';
import '../../SignInScreen/signIn.dart';

class haveAnAccount extends StatelessWidget {
  const haveAnAccount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return kTextButton(onPressed: (){
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SignInscreen())
      );
    },
        child: const Text("have an account?",)
    );
  }
}
