import 'package:flutter/material.dart';
import 'package:whatsappclone/Firebase/FirebaseAuth.dart';
import 'package:whatsappclone/components/scaffoldMessanger.dart';

import '../../../../components/iconButton.dart';
import '../../../../core/icons.dart';


class signoutBtn extends StatelessWidget {
  const signoutBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    FirebaseService firebase =  FirebaseService();

    return kIconButton(
      onPressed: () {
        firebase.SignOut();
        Navigator.of(context).pushNamed("welcome");
        showSnackbar(context, "Signed out");
      },
      myIcon: icons.logout,
    );
  }
}
