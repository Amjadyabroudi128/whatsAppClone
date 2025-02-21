import 'package:flutter/material.dart';

import '../../../components/TextField.dart';
import '../../../components/icons.dart';

class nameTextField extends StatelessWidget {
  const nameTextField({
    super.key,
    required this.name,
  });

  final TextEditingController name;

  @override
  Widget build(BuildContext context) {
    return kTextField(
      keyBoard: TextInputType.name,
      myController: name,
      myIcon: icons.name,
      label: Text("Name"),
    );
  }
}
