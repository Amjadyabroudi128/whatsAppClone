
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/ListTiles.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/TextStyles.dart';
import 'package:whatsappclone/components/iconButton.dart';
import 'package:whatsappclone/core/MyColors.dart';

import '../../../../core/icons.dart';
import '../../../../components/dividerWidget.dart';

Future<void> showImage(BuildContext context) async {
  await showModalBottomSheet(
    context: context,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    builder: (context) {
      return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Spacer(),
                  Text("Edit Profile photo", style: TextStyle(fontSize: 18, color: Colors.white),),
                  Spacer(),
                  kIconButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                      },
                    myIcon: icons.cancel
                  )
                ],
              ),
              BoxSpacing(myHeight: 9,),
              Card(
                color: Colors.grey[800],
                child: Column(
                  children: [
                    kListTile(
                      title: Text("Take Photo", style: Textstyles.saveBio,),
                      trailing: icons.camera,
                    ),
                    divider(),
                    kListTile(
                      title: Text("Choose Photo", style: Textstyles.saveBio,),
                      trailing: icons.whiteImage,
                      onTap: (){

                      },
                    ),
                    divider(),
                    kListTile(
                      title: Text("Delete Photo", style: TextStyle(fontSize: 17, color: myColors.redAccent),),
                      trailing: icons.deleteIcon,
                    ),
                  ],
                ),
              )
            ],
          ),
        );
    }
  );
}