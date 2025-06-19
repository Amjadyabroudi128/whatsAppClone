import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/Firebase/FirebaseAuth.dart';
import 'package:whatsappclone/components/TextButton.dart';
import 'package:whatsappclone/components/TextField.dart';
import 'package:whatsappclone/components/TextStyles.dart';
import 'package:whatsappclone/core/MyColors.dart';

import '../../../../components/flutterToast.dart';

class EditBio extends StatefulWidget {
  final String? bio;
  const EditBio({super.key, required this.bio});

  @override
  State<EditBio> createState() => _EditBioState();
}

class _EditBioState extends State<EditBio> {
  final TextEditingController bioController = TextEditingController();
  FirebaseService service = FirebaseService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: myColors.btmSheet,
      appBar: AppBar(
        // backgroundColor: Colors.grey,
        title: Text("Edit Your Bio",),
        actions: [
          editButton()
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: kTextField(
          enable: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: Colors.transparent
              )
          ),
          focused: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: Colors.transparent
              )
          ),
          filled: true,
          myController: bioController,
          maxLines: 9,
          hint: "Edit your Bio",
        ),
      ),
    );
  }
  editButton () {
    return kTextButton(
      onPressed: () async {
        String newBio = bioController.text.trim();
        if(newBio.isEmpty) {
          myToast("add someThing to your bio");
        } else if (newBio == (widget.bio ?? '')) {
          myToast("Nothing changed in the bio");
        } else {
          await service.updateBio(newBio);
          Navigator.of(context).pop();
        }
      },
      child: Text("Save",),
    );
  }
}
