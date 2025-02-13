import 'package:flutter/material.dart';

import '../../../TextStyles.dart';

class welcomeText extends StatelessWidget {
  const welcomeText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text("Welcome to WhatsApp", style: Textstyles.welcome,);
  }
}
