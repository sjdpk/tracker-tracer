import 'package:flutter/material.dart';

class AppTheme {
  static appDefaultTheme() {
    return ThemeData(
      brightness: Brightness.light,
      appBarTheme: const AppBarTheme(
        elevation: 0,
      ),
      useMaterial3: true,
    );
  }
}
