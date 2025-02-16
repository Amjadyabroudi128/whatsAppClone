import 'package:flutter/material.dart';

import '../../../components/TextStyles.dart';

class textFamily extends StatelessWidget {
  const textFamily({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text("You can Text, Family and friends", style: Textstyles.read,);
  }
}
