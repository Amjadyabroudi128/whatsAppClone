import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/core/TextStyles.dart';

import '../../../../Firebase/FirebaseAuth.dart';
import '../../../../components/SizedBox.dart';
import '../../../../components/TextButton.dart';
import '../../../../components/TextField.dart';
import '../../../../components/flutterToast.dart';
import '../../../../core/MyColors.dart';

class LinksScreen extends StatelessWidget {
  final TextEditingController linkController;
  final String link;
  const LinksScreen({super.key, required this.linkController,  required this.link});

  @override
  Widget build(BuildContext context) {
    FirebaseService service = FirebaseService();
    OutlineInputBorder enabled = OutlineInputBorder(borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
            color: Colors.transparent
        )
    );
    return FractionallySizedBox(
      heightFactor: 0.94,
      child: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(

            title: Text("Add link"),
            actions: [
              kTextButton(
                child: Text("Save", style: Textstyles.saveBio,),
                onPressed: ()async {
                  String newLink = linkController.text.trim();
                  if(newLink.isEmpty){
                    myToast("Your name is empty ");
                  } else if (newLink == link ){
                    myToast("Change something");
                  } else {
                    await service.addLink(linkController.text.trim());
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Instagram Link",),
                BoxSpacing(myHeight: 10,),
                kTextField(
                  enable: enabled,
                  filled: true,
                  myController: linkController,
                  maxLines: 2,
                  hint: "${linkController.text.isEmpty ? "Link" : linkController.text.trim()}",
                ),
                BoxSpacing(myHeight: 13,),
                Text("adding isntagram to your profile will make it visible", style: Textstyles.insta,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
