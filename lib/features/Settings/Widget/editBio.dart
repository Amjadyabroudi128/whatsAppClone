import 'package:flutter/material.dart';
import 'package:whatsappclone/components/TextField.dart';

class EditBio extends StatefulWidget {
  const EditBio({super.key});

  @override
  State<EditBio> createState() => _EditBioState();
}

class _EditBioState extends State<EditBio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Edit Your Bio", style: TextStyle(color: Colors.black),),
        actions: [
          TextButton(onPressed: (){}, child:
          Text("Save", style: TextStyle(color: Colors.black, fontSize: 20),))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: kTextField(
          maxLines: 9,
          hint: "Edit your Bio",
        ),
      ),
    );
  }
}
