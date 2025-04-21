import 'package:flutter/material.dart';
import 'package:whatsappclone/features/Settings/Widget/accountFunctions/signoutBtn.dart';


class signOut extends StatelessWidget {
  const signOut({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text("Sign out"),
        trailing: signoutBtn()
    );
  }
}
