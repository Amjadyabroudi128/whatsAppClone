
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/ListTiles.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/iconButton.dart';

import '../../../core/icons.dart';

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
                  kIconButton(onPressed: (){
                    Navigator.of(context).pop();},
                    myIcon: Icon(Icons.arrow_back),
                  ),
                  Spacer(),
                  Text("Edit Profile photo", style: TextStyle(fontSize: 18, color: Colors.white),),
                  Spacer(),
                  Icon(Icons.cancel, color: Colors.white,)
                ],
              ),
              BoxSpacing(myHeight: 9,),
              Card(
                color: Colors.grey,
                child: Column(
                  children: [
                    kListTile(
                      title: Text("Choose Photo"),
                      trailing: icons.image,
                    ),
                    kListTile(
                      title: Text("Choose Photo"),
                      trailing: icons.image,
                    ),
                    kListTile(
                      title: Text("Choose Photo"),
                      trailing: icons.image,
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