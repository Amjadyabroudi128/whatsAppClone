import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/TextField.dart';

class EditBio extends StatefulWidget {
  const EditBio({super.key});

  @override
  State<EditBio> createState() => _EditBioState();
}

class _EditBioState extends State<EditBio> {
  final TextEditingController bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCurrentBio();
  }

  Future<void> _loadCurrentBio() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance.collection("users").doc(uid).get();
      bioController.text = doc.data()?["bio"] ?? "";
    }
  }

  Future<void> _saveBio() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await FirebaseFirestore.instance.collection("users").doc(uid).update({
        "bio": bioController.text.trim(),
      });
      Navigator.pop(context); // Go back after saving
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        centerTitle: true,
        title: Text("Edit Your Bio", style: TextStyle(color: Colors.black)),
        actions: [
          TextButton(
            onPressed: _saveBio,
            child: Text("Save", style: TextStyle(color: Colors.black, fontSize: 20)),
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
