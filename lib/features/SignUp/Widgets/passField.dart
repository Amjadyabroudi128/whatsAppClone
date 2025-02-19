import 'package:flutter/material.dart';

import '../../../components/TextField.dart';
import '../../../components/icons.dart';

class passField extends StatelessWidget {
  const passField({
    super.key,
    required this.pass,
  });

  final TextEditingController pass;

  @override
  Widget build(BuildContext context) {
    return kTextField(
      myController: pass,
      label: Text("Password"),
      myIcon: icons.passIcon,
      border: OutlineInputBorder(),
    );
  }
}
