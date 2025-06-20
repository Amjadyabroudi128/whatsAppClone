import 'package:flutter/material.dart';
import 'package:whatsappclone/components/flutterToast.dart';

import '../../../../Firebase/FirebaseAuth.dart';
import '../../../../components/TextButton.dart';
import '../../../../components/TextField.dart';
import '../../../../core/TextStyles.dart';
import '../../../../core/MyColors.dart';

class editName extends StatelessWidget {
  final FirebaseService service;
  final TextEditingController nameController;
  final String name;
  const editName({
    Key? key,
    required this.service,
    required this.nameController, required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.94,
      child: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Edit Your Name",),
            actions: [
              kTextButton(
                onPressed: () async {
                  String newName = nameController.text.trim();
                  if(newName.isEmpty){
                    myToast("Your name is empty ");
                  } else if (newName == name ){
                    myToast("Change something");
                  } else {
                    await service.updateName(nameController.text.trim());
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
              enable: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: Colors.transparent
                  )
              ),
              filled: true,
              myController: nameController,
              maxLines: 9,
              hint: "Edit your Bio",
            ),
          ),
        ),
      ),
    );
  }
}

