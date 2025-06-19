import 'package:flutter/material.dart';
import 'package:whatsappclone/components/flutterToast.dart';

import '../../../../Firebase/FirebaseAuth.dart';
import '../../../../components/TextButton.dart';
import '../../../../components/TextField.dart';
import '../../../../components/TextStyles.dart';
import '../../../../core/MyColors.dart';

class Editbio extends StatelessWidget {
  final FirebaseService service;
  final TextEditingController bioController;
  final String bio;
  const Editbio({
    Key? key,
    required this.service,
    required this.bioController, required this.bio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.94,
      child: Scaffold(
        backgroundColor: myColors.btmSheet,
        appBar: AppBar(
          backgroundColor: myColors.familyText,
          title: const Text("Edit Your Bio",),
          actions: [
            kTextButton(
              onPressed: () async {
                String newBio = bioController.text.trim();
                if(newBio.isEmpty){
                  myToast("Your Bio is empty ");
                } else if (newBio == bio ){
                  myToast("Change something");
                } else {
                  await service.updateBio(bioController.text.trim());
                  Navigator.of(context).pop();
                }
              },
              child: Text("Save", style: Textstyles.saveBio),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: kTextField(
            filled: true,
            fillColor: myColors.familyText,
            myController: bioController,
            maxLines: 9,
            hint: "Edit your Bio",
          ),
        ),
      ),
    );
  }
}

