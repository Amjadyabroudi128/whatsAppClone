import 'package:flutter/material.dart';
import 'package:whatsappclone/Firebase/FirebaseAuth.dart';
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

class ThanksScreen extends StatefulWidget {
  const ThanksScreen({super.key});

  @override
  State<ThanksScreen> createState() => _ThanksScreenState();
}

class _ThanksScreenState extends State<ThanksScreen> {
  @override
  void initState() {
    super.initState();
    // Wait 4 seconds, then pop back.
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // Prevent accidental back until auto-pop
      body: Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle_outline, size: 72),
                SizedBox(height: 16),
                Text(
                  "Thanks!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  "We’ve received your issue. We’ll take a look shortly.",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
  }
}
