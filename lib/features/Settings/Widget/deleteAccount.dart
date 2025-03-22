import 'package:flutter/material.dart';
import 'package:whatsappclone/components/TextStyles.dart';
import 'package:whatsappclone/core/MyColors.dart';

import '../../../components/iconButton.dart';

class deleteAccount extends StatelessWidget {
  const deleteAccount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text("Delete Account",),
        trailing: kIconButton(
            onPressed: (){} ,
            myIcon: Icon(Icons.remove)
        )
    );
  }
}
