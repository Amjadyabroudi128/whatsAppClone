
 import 'package:flutter/material.dart';

Future btmSheet({required BuildContext context,
 required WidgetBuilder builder,Color? backgroundColor,
 bool isScrollControlled = false,   bool isDismissible = true,}) {
  return showModalBottomSheet(context: context, builder: builder, backgroundColor: backgroundColor,);
}