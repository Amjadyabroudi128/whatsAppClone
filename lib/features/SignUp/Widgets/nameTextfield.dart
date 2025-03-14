import 'package:flutter/material.dart';

import '../../../components/TextField.dart';
import '../../../core/icons.dart';

class nameField extends StatelessWidget {
  const nameField({
    super.key,
    required this.name,
  });

  final TextEditingController name;

  @override
  Widget build(BuildContext context) {
    return kTextField(
      myController: name,
      label: Text("Name"),
      myIcon: icons.person,
    );
  }
}
