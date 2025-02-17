import 'package:flutter/material.dart';

class elevatedBtn extends StatelessWidget {
  const elevatedBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (){
        Navigator.of(context).pushNamed("sign up");
      },
      child: Text("Agree and Continue"),
    );
  }
}
