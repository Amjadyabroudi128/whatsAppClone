import 'package:flutter/material.dart';
import 'package:whatsappclone/components/fSizedBox.dart';
import 'package:whatsappclone/components/flutterToast.dart';

import '../../../../Firebase/FirebaseAuth.dart';
import '../../../../components/TextButton.dart';
import '../../../../components/TextField.dart';
import '../../../../core/TextStyles.dart';
class editName extends StatelessWidget {
  final FirebaseService service;
  final TextEditingController nameController;
  final String name;
  const editName({
    Key? key,
    required this.service,
    required this.nameController, required this.name,
  }) : super(key: key);
 Future<void> updateName() async {
   final newName = nameController.text.trim();
   if(newName.isEmpty){
     myToast("Your name is empty ");
   } else if (newName == name ){
     myToast("Change something");
   } else {
     await service.updateName(nameController.text.trim());
   }
 }
  @override
  Widget build(BuildContext context) {
    OutlineInputBorder enabled = OutlineInputBorder(borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
            color: Colors.transparent
        )
    );
    return fSizedBox(
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
                  updateName();
                  Navigator.of(context).pop();
                },
                child: Text("Save", style: Textstyles.saveBio),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: kTextField(
              enable: enabled,
              filled: true,
              myController: nameController,
              // maxLines: 1,
              hint: "Edit your Bio",
              onFieldSubmitted: (value) async {
                updateName();
                Navigator.of(context).pop();
              },
            ),
          ),

        ),
      ),
    );
  }
}

