import 'package:flutter/material.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/TextButton.dart';
import 'package:whatsappclone/components/fSizedBox.dart';

import '../../../../components/TextField.dart';

class Editemail extends StatelessWidget {
  final String email;
  final TextEditingController emailController;
  const Editemail({super.key,required this.email, required this.emailController});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: fSizedBox(
        heightFactor: 0.94,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Edit your email"),
            actions: [
              kTextButton(
                onPressed: ()async {
                  final newEmail = emailController.text.trim();
                },
                child: Text("Save"),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("this is your Currnet Email"),
                BoxSpacing(myHeight: 10,),
                kTextField(
                  filled: true,
                  maxLines: 1,
                  hint: "${email}",
                  enabled: false,
                ),
                BoxSpacing(myHeight: 10,),
                Text("Change email"),
                BoxSpacing(myHeight: 10,),
                kTextField(
                  filled: true,
                  maxLines: 1,
                  hint: "Your email",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
