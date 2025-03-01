import 'package:flutter/material.dart';

import '../../../components/TextButton.dart';
import '../../../components/TextStyles.dart';

class NotRegisterd extends StatelessWidget {
  const NotRegisterd({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return kTextButton(
        onPressed: (){
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Signupscreen())
          );
        }, child:
    Text("Not Registered?", style: Textstyles.forgotPass,)
    );
  }
}
