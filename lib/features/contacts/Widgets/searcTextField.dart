import 'package:flutter/material.dart';

import '../../../components/TextField.dart';
import '../../../core/icons.dart';

class searchTextField extends StatelessWidget {
  const searchTextField({
    super.key,
    required this.userController,
  });

  final TextEditingController userController;

  @override
  Widget build(BuildContext context) {
    return kTextField(
      textInputAction: TextInputAction.go,
      myIcon: icons.search,
      hint: "Search user",
      myController: userController,
    );
  }
}
