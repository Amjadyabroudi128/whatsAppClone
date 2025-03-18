import 'package:flutter/material.dart';

import '../../../components/iconButton.dart';

class deleteAccount extends StatelessWidget {
  const deleteAccount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text("Delete Account", style: TextStyle(fontSize: 19, color: Colors.red),),
        trailing: kIconButton(
            onPressed: (){} ,
            myIcon: Icon(Icons.remove)
        )
    );
  }
}
