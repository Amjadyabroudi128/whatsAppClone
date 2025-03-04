import 'package:flutter/material.dart';
import 'package:whatsappclone/Firebase/FirebaseAuth.dart';
import 'package:whatsappclone/components/scaffoldMessanger.dart';

import '../../../components/iconButton.dart';
import '../../../components/icons.dart';
import '../../welcomeScreen/welcome.dart';

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
        showSnackbar(context, "Signed out");
      },
      myIcon: icons.logout,
    );
  }
}
