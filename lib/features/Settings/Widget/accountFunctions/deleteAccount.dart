import 'package:flutter/material.dart';
import 'package:whatsappclone/components/ListTiles.dart';
import 'package:whatsappclone/components/flutterToast.dart';
import 'package:whatsappclone/core/icons.dart';
import '../../../../Firebase/FirebaseAuth.dart';
import '../../../../components/iconButton.dart';

class deleteAccount extends StatelessWidget {
  const deleteAccount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    FirebaseService service =  FirebaseService();

    return kListTile(
        title: Text("Delete Account",),
        trailing: kIconButton(
            onPressed: () async {
              await service.deleteAccount();
              Navigator.of(context).pushNamed("welcome");
              myToast("account deleted");
            },
            myIcon: icons.remove
        )
    );
  }
}
