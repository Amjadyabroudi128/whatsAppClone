import 'package:flutter/material.dart';
import 'package:whatsappclone/components/ElevatedBtn.dart';

class elevatedBtn extends StatelessWidget {
  const elevatedBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return kElevatedBtn(
      onPressed: (){
        Navigator.of(context).pushNamed("sign up");
      },
      child: const Text("Agree and Continue"),
    );
  }
}
