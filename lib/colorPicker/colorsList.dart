import 'package:flutter/material.dart';

final Map<Color, String> colorNames = {
  Colors.red: "Red",
  Colors.green: "Green",
  Colors.green.shade700: "shade700",
  Colors.blue: "Blue",
  Colors.orange: "Orange",
  Colors.purple: "Purple",
  Colors.yellow: "Yellow",
  Colors.pink: "Pink",
  Colors.teal: "Teal",
  Colors.teal.shade800: "teal800",
  Colors.white: "white",
};
Color getTextColor(Color backgroundColor) {
  return ThemeData.estimateBrightnessForColor(backgroundColor) == Brightness.dark
      ? Colors.white
      : Colors.black;
}