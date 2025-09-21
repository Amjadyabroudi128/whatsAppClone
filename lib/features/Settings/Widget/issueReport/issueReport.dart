import 'package:flutter/material.dart';
import 'package:whatsappclone/Firebase/FirebaseAuth.dart';
import 'package:whatsappclone/components/ElevatedBtn.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/TextField.dart';
import 'package:whatsappclone/components/flutterToast.dart';
import 'package:whatsappclone/components/iconButton.dart';

import '../../../../core/TextStyles.dart';
import '../../../../core/icons.dart';
import 'Widgets/thanksScreen.dart';
final _formKey = GlobalKey<FormState>();
class IssueReport extends StatelessWidget {
  const IssueReport({super.key, required this.emailController});
  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    final TextEditingController issueController = TextEditingController();
    FirebaseService service = FirebaseService();

    void removeController() {
      emailController.clear();
      issueController.clear();
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 22, left: 1),
                  child: kIconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      removeController();
                    },
                    myIcon: icons.arrow,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
                const BoxSpacing(myHeight: 60),
                const Center(
                  child: Text(
                    "What to report?",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const BoxSpacing(myHeight: 20),

                // Email field with padding
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: "Email ",
                          style: Textstyles.important,
                          children: [
                            TextSpan(
                              text: "*",
                              style: Textstyles.deleteStyle,
                            ),
                          ],
                        ),
                      ),
                      const BoxSpacing(myHeight: 9),
                      kTextField(
                        myController: emailController,
                        hint: "Your email",
                      ),
                    ],
                  ),
                ),
                const BoxSpacing(myHeight: 20),

                // Issue field with padding
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: "Issue ",
                          style: Textstyles.important,
                          children: [
                            TextSpan(
                              text: "*",
                              style: Textstyles.deleteStyle,
                            ),
                          ],
                        ),
                      ),
                      const BoxSpacing(myHeight: 7),
                      kTextField(
                        hint: "Please describe your Issue...",
                        minLines: 4,
                        myController: issueController,
                        validator: (issue) => issue!.isEmpty ? "don't leave this empty" : null,
                      ),
                    ],
                  ),
                ),
                const BoxSpacing(myHeight: 20),

                // Submit button centered
                Center(
                  child: kElevatedBtn(
                    onPressed: () async {
                      final email = emailController.text.trim();
                      final issue = issueController.text.trim();
                      _formKey.currentState!.validate();
                      if (email.isEmpty || issue.isEmpty) {
                        myToast("Please fill the fields before submitting");
                        return;
                      }
                      final emailRegex =
                      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(email)) {
                        myToast("Please enter a valid email address");
                        return;
                      }
                      FocusScope.of(context).unfocus();
                      await service.reportIssue(email, issue);

                      removeController();
                      if (!context.mounted) return;

                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const ThanksScreen()),
                      );
                    },
                    child: const Text("Submit"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
