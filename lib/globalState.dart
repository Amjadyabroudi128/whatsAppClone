import 'package:flutter/material.dart';

// Global ValueNotifier for the selected color
final ValueNotifier<Color> selectedThemeColor = ValueNotifier<Color>(Colors.white);
ValueNotifier<String?> currentReceiverId = ValueNotifier(null);

