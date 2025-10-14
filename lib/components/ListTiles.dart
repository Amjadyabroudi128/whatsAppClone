import 'package:flutter/material.dart';

class kListTile extends StatelessWidget {
  final Widget? title;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Widget? leading;
  final Widget? subtitle;
  final bool? enabled;
  const kListTile({super.key, this.title, this.onTap, this.trailing, this.leading, this.subtitle, this.enabled});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      subtitle: subtitle,
      title: title,
      onTap: onTap,
      trailing: trailing,
      leading: leading,
      enabled: enabled ?? true,
    );
  }
}
