import 'package:flutter/material.dart';

class Themes {
  static ThemeData getLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      colorSchemeSeed: Colors.deepPurple,
    );
  }

  static ThemeData getDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      colorSchemeSeed: Colors.deepPurple,
    );
  }
}