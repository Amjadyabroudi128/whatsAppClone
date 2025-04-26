
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/ListTiles.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/TextStyles.dart';
import 'package:whatsappclone/components/iconButton.dart';
import 'package:whatsappclone/core/MyColors.dart';
import 'package:whatsappclone/features/Settings/Widget/ProfileCard/imageStream.dart';
import '../../../../Firebase/FirebaseCollections.dart';
import '../../../../core/icons.dart';
import '../../../../components/dividerWidget.dart';
import "package:whatsappclone/utils/pickImage.dart" as url;
Future<void> showImage(BuildContext context, {Future<void> Function(String imageUrl)? addToFirebase}) async {
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 27),
                      child: ProfileStream(),
                    ),
                     BoxSpacing(mWidth: 18,),
                     Text(
                      "Edit Profile photo",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
                const Spacer(),
                kIconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  myIcon: icons.cancel,
                ),
              ],
            ),
            BoxSpacing(myHeight: 9),
            Card(
              color: Colors.grey[800],
              child: Column(
                children: [
                  kListTile(
                    title: Text("Take Photo", style: Textstyles.saveBio),
                    trailing: icons.camera,
                    onTap: () async {
                      String? imageUrl = await url.takeImage();
                      if (imageUrl != null && addToFirebase != null) {
                        await addToFirebase(imageUrl);
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  divider(),
                  kListTile(
                    title: Text("Choose Photo", style: Textstyles.saveBio),
                    trailing: icons.whiteImage,
                    onTap: () async {
                      String? imageUrl = await url.pickImage();
                      if (imageUrl != null && addToFirebase != null) {
                        await addToFirebase(imageUrl);
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  divider(),
                  kListTile(
                    title: Text(
                      "Delete Photo",
                      style: Textstyles.deletemessage,
                    ),
                    trailing: icons.deleteIcon,
                    onTap: () {
                      userC.doc(FirebaseAuth.instance.currentUser!.uid)
                          .update({"image": FieldValue.delete()});
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      );
    },
  );
}