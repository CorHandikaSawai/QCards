import 'package:flutter/material.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: const Color(0xFF1976D2),
    scaffoldBackgroundColor: const Color(0xFFFAFAFA),
    cardColor: Colors.white,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 16),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: const OutlineInputBorder(),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF1976D2)),
      ),
      labelStyle: TextStyle(color: Colors.grey[800]),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 16, color: Color(0xFF212121)),
      labelLarge: TextStyle(fontWeight: FontWeight.bold),
    ),
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: const Color(0xFF121212),
    cardColor: const Color(0xFF1E1E1E),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 16, color: Colors.white),
      labelLarge: TextStyle(fontWeight: FontWeight.bold),
    ),
  );
}
