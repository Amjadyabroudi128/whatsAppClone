import 'package:flutter/material.dart';
import 'package:whatsappclone/components/ElevatedBtn.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/TextField.dart';
import 'package:whatsappclone/components/flutterToast.dart';

class IssueReport extends StatelessWidget {
  const IssueReport({super.key, required this.emailController});
  final TextEditingController emailController;
  @override
  Widget build(BuildContext context) {
    final TextEditingController issueController = TextEditingController();
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const BoxSpacing(myHeight: 60,),
                const Center(child: Text("What to report?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
                const BoxSpacing(myHeight: 9,),
                 kTextField(
                  myController: emailController,
                  hint: "Your email ",
                ),
                const BoxSpacing(myHeight: 12,),
                 kTextField(
                  hint: "Please describe your Issue...",
                  minLines: 4,
                  myController: issueController,
                ),
                const BoxSpacing(myHeight: 12,),
                kElevatedBtn(onPressed: (){
                  if(emailController.text.isEmpty || issueController.text.isEmpty) {
                    myToast("Please fill the fields before submitting");
                  }

                }, child: const Text("Submit"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
