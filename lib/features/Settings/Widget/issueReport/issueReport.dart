import 'package:flutter/material.dart';
import 'package:whatsappclone/components/ElevatedBtn.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/TextButton.dart';
import 'package:whatsappclone/components/TextField.dart';

class IssueReport extends StatelessWidget {
  const IssueReport({super.key, required this.emailController});
  final TextEditingController emailController;
  @override
  Widget build(BuildContext context) {
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
                const Center(child: Text("What to report?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
                const BoxSpacing(myHeight: 9,),
                const kTextField(
                  hint: "Your email ",
                ),
                const BoxSpacing(myHeight: 12,),
                const kTextField(
                  hint: "Please describe your Issue...",
                  minLines: 4,
                ),
                const BoxSpacing(myHeight: 12,),
                kElevatedBtn(onPressed: (){

                }, child: const Text("Submit"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
