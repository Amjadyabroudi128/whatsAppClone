
import 'package:flutter/material.dart';

final Map<Color, String> colorNames = {
  Colors.red: "Red",
  Colors.green: "Green",
  Colors.green.shade700: "shade700",
  Colors.blue: "Blue",
  Colors.brown.shade600: "lightB",
  Colors.brown: "brown",
  Colors.purple: "Purple",
  Colors.yellow: "Yellow",
  Colors.pink: "Pink",
  Colors.teal: "Teal",
  Colors.teal.shade800: "teal800",
  Colors.blueGrey: "blueG",
  Colors.blueGrey.shade700: "blue7",
  Colors.white: "white",
};
Color getTextColor(Color backgroundColor) {
  return ThemeData.estimateBrightnessForColor(backgroundColor) == Brightness.dark
      ? Colors.white
      : Colors.black;
}