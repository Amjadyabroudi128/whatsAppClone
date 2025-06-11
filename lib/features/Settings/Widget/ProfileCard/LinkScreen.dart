import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/TextStyles.dart';

import '../../../../Firebase/FirebaseAuth.dart';
import '../../../../components/SizedBox.dart';
import '../../../../components/TextButton.dart';
import '../../../../components/TextField.dart';
import '../../../../core/MyColors.dart';

class LinksScreen extends StatelessWidget {
  final TextEditingController linkController;

  const LinksScreen({super.key, required this.linkController, required link});

  @override
  Widget build(BuildContext context) {
    FirebaseService service = FirebaseService();
    return FractionallySizedBox(
      heightFactor: 0.94,
      child: Scaffold(
        backgroundColor: myColors.btmSheet,
        appBar: AppBar(
          backgroundColor: Colors.grey,
          title: Text("Add link"),
          actions: [
            kTextButton(
              child: Text("Save", style: Textstyles.saveBio,),
              onPressed: ()async {
                await service.addLink(linkController.text.trim());
                Navigator.of(context).pop();
              },
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Instagram UserName", style: TextStyle(color: Colors.white),),
              BoxSpacing(myHeight: 10,),
              kTextField(
                filled: true,
                fillColor: Colors.grey,
                myController: linkController,
                maxLines: 1,
                hint: "${linkController.text.isEmpty ? "Link" : linkController}",
              ),
              BoxSpacing(myHeight: 10,),
              Text("adding isntagram to your profile will make it visible", style: TextStyle(fontSize: 13, color: CupertinoColors.systemGrey),)
            ],
          ),
        ),
      ),
    );
  }
}
