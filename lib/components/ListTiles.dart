import 'package:flutter/material.dart';

class kListTile extends StatelessWidget {
  final Widget? title;
  final VoidCallback? onTap;
  final Widget? trailing;
  const kListTile({super.key, this.title, this.onTap, this.trailing});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: title,
      onTap: onTap,
      trailing: trailing,
    );
  }
}
