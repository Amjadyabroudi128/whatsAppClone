import 'package:flutter/material.dart';
import 'package:whatsappclone/components/ListTiles.dart';
import 'package:whatsappclone/components/flutterToast.dart';
import 'package:whatsappclone/components/listTilesOptions.dart';
import 'package:whatsappclone/core/icons.dart';
import '../../../../Firebase/FirebaseAuth.dart';
import '../../../../components/TextButton.dart';
import '../../../../components/TextStyles.dart';
import '../../../../components/iconButton.dart';

class deleteAccount extends StatelessWidget {
  const deleteAccount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    FirebaseService service =  FirebaseService();
    return Options(
      context: context,
      label: Text("DeleteAccount"),
      trailing: icons.remove,
      onTap: () async {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("you are about to Delete your account"),
            content: Text("Are you sure you wanna leave us? "),
              actions: [
              kTextButton(
              onPressed: (){
                Navigator.of(context).pop();
                FocusScope.of(context).unfocus();
        },
                child: Text("Cancel"),
              ),
                kTextButton(
                  onPressed: () async {
                    Navigator.of(context).pushNamed("welcome");
                    await service.deleteAccount();
                    myToast("account deleted");
                  },
                  child: Text("Delete", style: Textstyles.deleteStyle,),
                ),
              ]
          )
        );
      }
    );
  }
}
