import 'package:flutter/material.dart';
import 'package:whatsappclone/components/flutterToast.dart';
import 'package:whatsappclone/components/listTilesOptions.dart';
import 'package:whatsappclone/features/Settings/Widget/accountFunctions/signoutBtn.dart';

import '../../../../Firebase/FirebaseAuth.dart';
import '../../../../core/icons.dart';


class signOut extends StatelessWidget {
  const signOut({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    FirebaseService firebase =  FirebaseService();
    return Options(
      context: context,
      label: Text("SignOut"),
      trailing: icons.logout,
      onTap: (){
        firebase.SignOut();
        Navigator.of(context).pushNamed("welcome");
        myToast("Signed out ");
      }
    );
  }
}
