import 'package:flutter/material.dart';

import '../../components/icons.dart';

class passField extends StatelessWidget {
  const passField({
    super.key,
    required this.pass,
  });

  final TextEditingController pass;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: pass,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: "Password",
        border: OutlineInputBorder(),
        prefixIcon: icons.passIcon
      ),
    );
  }
}
