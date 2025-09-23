import 'package:flutter/material.dart';
import 'package:whatsappclone/components/flutterToast.dart';
import 'package:whatsappclone/components/listTilesOptions.dart';
import 'package:whatsappclone/core/icons.dart';
import '../../../../Firebase/FirebaseAuth.dart';
import '../../../../components/TextButton.dart';
import '../../../../core/TextStyles.dart';

class deleteAccount extends StatelessWidget {
  final String? messageId;

  const deleteAccount({
    super.key, this.messageId,
  });

  @override
  Widget build(BuildContext context) {
    FirebaseService service =  FirebaseService();
    return Options(
      context: context,
      label: const Text("DeleteAccount"),
      trailing: icons.remove(context),
      onTap: () async {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("you are about to Delete your account"),
            content: const Text("Are you sure you wanna leave us? "),
              actions: [
              kTextButton(
              onPressed: (){
                Navigator.of(context).pop();
                FocusScope.of(context).unfocus();
        },
                child: const Text("Cancel"),
              ),
                kTextButton(
                  onPressed: () async {
                    Navigator.of(context).pushNamed("welcome");
                    await service.deleteAccount();
                    myToast("account deleted");
                    // print(FirebaseAuth.instance.currentUser!.email);
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
