import 'package:flutter/material.dart';

import '../testName.dart';

class continueBtn extends StatelessWidget {
  const continueBtn({
    super.key,
    required this.name,
  });

  final TextEditingController name;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text("Continue"),
      onPressed: (){
        if (name.text.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Testname(name: name.text),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Please enter your name")),
          );
        }
      },

    );
  }
}
