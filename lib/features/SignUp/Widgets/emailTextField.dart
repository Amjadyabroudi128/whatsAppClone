import 'package:flutter/material.dart';
import 'package:whatsappclone/components/TextField.dart';

import '../../../components/icons.dart';


class emailField extends StatelessWidget {
  const emailField({
    super.key,
    required this.myEmail,
  });

  final TextEditingController myEmail;

  @override
  Widget build(BuildContext context) {
    return kTextField(
      keyBoard: TextInputType.emailAddress,
      myController: myEmail,
      border: OutlineInputBorder(),
      myIcon: icons.emailIcon,
      label: Text("Email"),
    );
  }
}
