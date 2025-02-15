
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/Strings.dart';

import '../../../components/TextStyles.dart';

class welcomeText extends StatelessWidget {
  const welcomeText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(Strings.Welcome, style: Textstyles.welcome,);
  }
}
