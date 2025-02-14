import 'package:flutter/material.dart';
import 'package:whatsappclone/components/TextStyles.dart';

class richText extends StatelessWidget {
  const richText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'Read our ',
        style: TextStyle(fontSize: 20, color: Colors.grey),
        children: <TextSpan>[
          TextSpan(text: 'Privacy Policy.', style: Textstyles.privacy),
          TextSpan(text: 'Tap "Agree & continue to accept tge'),
          TextSpan(text: "Terms of Services", style: TextStyle(color: Colors.green))
        ],
      ),
    );
  }
}
