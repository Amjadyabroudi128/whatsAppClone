import 'package:flutter/material.dart';

Future<T?> btmSheet<T>({
 required BuildContext context,
 required WidgetBuilder builder,
 Color? backgroundColor,
 bool isScrollControlled = false,
 bool isDismissible = true,
 bool? useRootNavigator
}) {
 return showModalBottomSheet<T>(
  context: context,
  isScrollControlled: isScrollControlled,
  isDismissible: isDismissible,
  backgroundColor: backgroundColor,
  useRootNavigator: useRootNavigator ?? false,
  builder: builder,
  shape:  const RoundedRectangleBorder(
   borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  ),
 );
}
