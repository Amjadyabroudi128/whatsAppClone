import 'package:flutter/material.dart';

import '../../../../Firebase/FirebaseAuth.dart';
import '../../../../components/TextButton.dart';
import '../../../../components/TextField.dart';
import '../../../../components/TextStyles.dart';
import '../../../../core/MyColors.dart';

class editName extends StatelessWidget {
  final FirebaseService service;
  final TextEditingController nameController;

  const editName({
    Key? key,
    required this.service,
    required this.nameController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.94,
      child: Scaffold(
        backgroundColor: myColors.btmSheet,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.grey,
          title: const Text("Edit Your Name", style: TextStyle(color: Colors.white)),
          actions: [
            kTextButton(
              onPressed: () {
                service.updateName(nameController.text.trim());
                Navigator.of(context).pop();
              },
              child: Text("Save", style: Textstyles.saveBio),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: kTextField(
            filled: true,
            fillColor: Colors.grey,
            myController: nameController,
            maxLines: 9,
            hint: "Edit your name",
          ),
        ),
      ),
    );
  }
}

