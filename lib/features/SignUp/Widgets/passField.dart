import 'package:flutter/material.dart';
import 'package:whatsappclone/components/iconButton.dart';

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
  bool passwordVisible = true;
 @override
  void initState() {
    super.initState();
    passwordVisible = false;
  }
  @override
  Widget build(BuildContext context) {
    return kTextField(
      icon: kIconButton(
        myIcon: Icon(passwordVisible ? Icons.visibility_off : Icons.visibility ),
        onPressed: (){
          setState(() {
            passwordVisible = !passwordVisible;
          });
        },
      ),
      myController: widget.pass,
      label: Text("Password"),
      myIcon: icons.passIcon,
      obsecureText: !passwordVisible,
    );
  }
}
