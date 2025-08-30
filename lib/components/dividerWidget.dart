import 'package:flutter/material.dart';
import 'package:whatsappclone/core/MyColors.dart';

class divider extends StatelessWidget {
  const divider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      indent: 19,
      endIndent: 10,
      color:MyColors.DividerClr,
    );
  }
}
