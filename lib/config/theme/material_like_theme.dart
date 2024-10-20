import 'package:flutter/material.dart';

class MaterialLikeTheme {
  static ThemeData theme() {
    return ThemeData.light().copyWith(
      snackBarTheme: const SnackBarThemeData(
        contentTextStyle: TextStyle(color: Color(0xFFFEF7FF)),
      ),
    );
  }
}
