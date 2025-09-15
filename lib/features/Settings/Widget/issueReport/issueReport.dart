import 'package:flutter/material.dart';
import 'package:whatsappclone/Firebase/FirebaseAuth.dart';
import 'package:whatsappclone/components/ElevatedBtn.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/TextField.dart';
import 'package:whatsappclone/components/flutterToast.dart';

import 'Widgets/thanksScreen.dart';

class IssueReport extends StatelessWidget {
  const IssueReport({super.key, required this.emailController});
  final TextEditingController emailController;
  @override
  Widget build(BuildContext context) {
    final TextEditingController issueController = TextEditingController();
    FirebaseService service = FirebaseService();
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
                kElevatedBtn(
                  onPressed: () async {
                    if (emailController.text.isEmpty || issueController.text.isEmpty) {
                      myToast("Please fill the fields before submitting");
                      return;
                    }
                    FocusScope.of(context).unfocus();
                    // Submit first
                    await service.reportIssue(
                      emailController.text.trim(),
                      issueController.text.trim(),
                    );

                    // Optional toast
                    // myToast("We have received your issue");
                    emailController.clear();
                    issueController.clear();
                    if (!context.mounted) return;

                    // Replace the current screen with the Thanks screen.
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const ThanksScreen()),
                    );
                  },
                  child: const Text("Submit"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

