import 'package:flutter/material.dart';

class kListTile extends StatelessWidget {
  final Widget? title;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Widget? leading;
  const kListTile({super.key, this.title, this.onTap, this.trailing, this.leading});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: title,
      onTap: onTap,
      trailing: trailing,
      leading: leading,
    );
  }
}
