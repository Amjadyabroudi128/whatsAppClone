import 'package:flutter/material.dart';

import '../../../components/TextField.dart';
import '../../../components/icons.dart';

class passField extends StatefulWidget {
  const passField({
    super.key,
    required this.pass,
  });

  final TextEditingController pass;

  @override
  State<passField> createState() => _passFieldState();
}

class _passFieldState extends State<passField> {
  bool passwordVisible = false;
 @override
  void initState() {
    // TODO: implement initState
    passwordVisible = true;
  }
  @override
  Widget build(BuildContext context) {
    return kTextField(
      icon: IconButton(
        icon: Icon(passwordVisible ? Icons.visibility_off : Icons.visibility ),
        onPressed: (){
          setState(() {
            passwordVisible = !passwordVisible;
          });
        },
      ),
      myController: widget.pass,
      label: Text("Password"),
      myIcon: icons.passIcon,
      border: OutlineInputBorder(),
      obsecureText: !passwordVisible,
    );
  }
}
