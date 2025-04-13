import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/Firebase/FirebaseAuth.dart';
import 'package:whatsappclone/components/TextButton.dart';
import 'package:whatsappclone/components/TextField.dart';

class EditBio extends StatefulWidget {
  const EditBio({super.key});

  @override
  State<EditBio> createState() => _EditBioState();
}

class _EditBioState extends State<EditBio> {
  final TextEditingController bioController = TextEditingController();
  FirebaseService service = FirebaseService();
  @override
  void initState() {
    super.initState();
    service.getBio();
    loadBio();
  }
  void loadBio() async {
    String? bio = await service.getBio();
    if (bio != null) {
      setState(() {
        bioController.text = bio;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        backgroundColor: Colors.grey,
        centerTitle: true,
        title: Text("Edit Your Bio", style: TextStyle(color: Colors.white)),
        actions: [
          kTextButton(
            onPressed: (){
              service.updateBio(bioController.text.trim());
              Navigator.of(context).pop();
            },
            child: Text("Save", style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: kTextField(
          filled: true,
          fillColor: Colors.grey,
          myController: bioController,
          maxLines: 9,
          hint: "Edit your Bio",
        ),
      ),
    );
  }
}
