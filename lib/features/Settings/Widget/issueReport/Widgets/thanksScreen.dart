import 'package:flutter/material.dart';
import 'package:whatsappclone/core/TextStyles.dart';
import 'package:whatsappclone/core/icons.dart';


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
    return Scaffold(
      // Prevent accidental back until auto-pop
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              icons.thanks(context),
              const SizedBox(height: 16),
               Text(
                "Thanks!",
                style: Textstyles.thanks ,
              ),
              const SizedBox(height: 8),
              const Text(
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
