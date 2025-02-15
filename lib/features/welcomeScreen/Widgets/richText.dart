import 'package:flutter/material.dart';
import 'package:whatsappclone/components/Strings.dart';
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
        text: Strings.read,
        style: Textstyles.read,
        children: <TextSpan>[
          TextSpan(text: 'Privacy Policy.', style: Textstyles.privacy),
          TextSpan(text: 'Tap "Agree & continue to accept the'),
          TextSpan(text: "Terms of Services", style: Textstyles.privacy)
        ],
      ),
    );
  }
}
