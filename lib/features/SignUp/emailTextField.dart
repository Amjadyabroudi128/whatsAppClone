import 'package:flutter/material.dart';

class emailField extends StatelessWidget {
  const emailField({
    super.key,
    required this.myEmail,
  });

  final TextEditingController myEmail;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: myEmail,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: "Email",
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.email),
      ),
    );
  }
}
