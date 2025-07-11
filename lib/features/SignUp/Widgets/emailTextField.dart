import 'package:flutter/material.dart';
import 'package:whatsappclone/components/TextField.dart';

import '../../../core/icons.dart';


class emailField extends StatelessWidget {
  const emailField({
    super.key,
    required this.myEmail,
  });

  final TextEditingController myEmail;

  @override
  Widget build(BuildContext context) {
    return kTextField(
      textInputAction: TextInputAction.next,
      keyBoard: TextInputType.emailAddress,
      myController: myEmail,
      myIcon: icons.emailIcon,
      label: Text("Email"),
    );
  }
}
