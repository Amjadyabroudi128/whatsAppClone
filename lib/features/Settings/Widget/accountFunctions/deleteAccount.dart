import 'package:flutter/material.dart';
import 'package:whatsappclone/components/ListTiles.dart';
import 'package:whatsappclone/core/icons.dart';
import '../../../../components/iconButton.dart';

class deleteAccount extends StatelessWidget {
  const deleteAccount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return kListTile(
        title: Text("Delete Account",),
        trailing: kIconButton(
            onPressed: (){} ,
            myIcon: icons.remove
        )
    );
  }
}
