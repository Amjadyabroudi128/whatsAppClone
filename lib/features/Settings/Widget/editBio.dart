import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/TextButton.dart';
import 'package:whatsappclone/components/TextField.dart';

class EditBio extends StatefulWidget {
  const EditBio({super.key});

  @override
  State<EditBio> createState() => _EditBioState();
}

class _EditBioState extends State<EditBio> {
  final TextEditingController bioController = TextEditingController();
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final users = FirebaseFirestore.instance.collection("users");
  @override
  void initState() {
    super.initState();
    // _loadCurrentBio();
  }

  // Future<void> _loadCurrentBio() async {
  //
  //   if (uid != null) {
  //     final doc = await FirebaseFirestore.instance.collection("users").doc(uid).get();
  //     bioController.text = doc.data()?["bio"] ?? "";
  //   }
  // }
  //
  // Future<void> _saveBio() async {
  //   final uid = FirebaseAuth.instance.currentUser?.uid;
  //   if (uid != null) {
  //     await FirebaseFirestore.instance.collection("users").doc(uid).update({
  //       "bio": bioController.text.trim(),
  //     });
  //     Navigator.pop(context); // Go back after saving
  //   }
  // }

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
            onPressed: (){},
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
