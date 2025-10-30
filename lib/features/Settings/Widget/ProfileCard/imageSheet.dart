import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/ListTiles.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/flutterToast.dart';
import 'package:whatsappclone/core/TextStyles.dart';
import 'package:whatsappclone/components/iconButton.dart';
import 'package:whatsappclone/components/kCard.dart';
import 'package:whatsappclone/features/Settings/Widget/ProfileCard/imageStream.dart';
import '../../../../Firebase/FirebaseCollections.dart';
import '../../../../core/icons.dart';
import '../../../../components/dividerWidget.dart';
import "package:whatsappclone/utils/pickImage.dart" as url;
import '../../../BottomNavBar/BottomNavBar.dart';
Future<void> showImage(BuildContext context, {Future<void> Function(String imageUrl)? addToFirebase}) async {
  // Get current user's image status
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final userDoc = await userC.doc(userId).get();
  final userData = userDoc.data() as Map<String, dynamic>?;
  final hasImage = userData?['image'] != null;

  await showModalBottomSheet(
    context: context,
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
                    const BoxSpacing(mWidth: 18,),
                    Text(
                      "Edit Profile photo",
                      style: Textstyles.editProfile,
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
            const BoxSpacing(myHeight: 9),
            kCard(
              child: Column(
                children: [
                  kListTile(
                    title: Text("Take Photo", style: Textstyles.saveBio),
                    trailing: icons.camera(context),
                    onTap: () async {
                      Navigator.of(context).pop();
                      String? imageUrl = await url.takeImage();
                      if (imageUrl != null && addToFirebase != null) {
                        await addToFirebase(imageUrl);
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  const divider(),
                  kListTile(
                    title: const Text("Choose Photo",),
                    trailing: icons.whiteImage(context),
                    onTap: () async {
                      Navigator.of(context).pop();
                      String? imageUrl = await url.pickImage();
                      if (imageUrl != null && addToFirebase != null) {
                        await addToFirebase(imageUrl);
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  if (hasImage) ...[
                    const divider(),
                    kListTile(
                      title: Text(
                        "Delete Photo",
                        style: Textstyles.deletemessage,
                      ),
                      trailing: icons.deleteIcon,
                      onTap: () async {
                        // Navigator.of(context).pop();
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => const Bottomnavbar()
                            )
                        );
                        myToast("Profile picture deleted");
                        await userC.doc(FirebaseAuth.instance.currentUser!.uid)
                            .update({"image": FieldValue.delete()});
                      },
                    ),
                  ],
                ],
              ),
            )
          ],
        ),
      );
    },
  );
}