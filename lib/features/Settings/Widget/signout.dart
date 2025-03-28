import 'package:flutter/material.dart';

import 'signoutBtn.dart';

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
