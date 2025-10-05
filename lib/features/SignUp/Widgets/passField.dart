import 'package:flutter/material.dart';
import 'package:whatsappclone/components/iconButton.dart';

import '../../../components/TextField.dart';
import '../../../core/icons.dart';

class passField extends StatefulWidget {
  const passField({
    super.key,
    required this.pass,
  });

  final TextEditingController pass;

  @override
  State<passField> createState() => _passFieldState();
}

class _passFieldState extends State<passField> {
  final ValueNotifier<bool> passwordV = ValueNotifier<bool>(false);
 @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: passwordV,
      builder: (context,value, _) {
        return kTextField(
          textInputAction: TextInputAction.done,
          maxLines: 1,
          icon: kIconButton(
            myIcon: value ? icons.visibility : icons.visibility_off,
            onPressed: (){
              passwordV.value = !value;
            },
          ),
          myController: widget.pass,
          label: const Text("Password"),
          myIcon: icons.passIcon,
          obscureText: !value,
        );
      },
    );
  }
}
