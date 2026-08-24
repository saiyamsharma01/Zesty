import 'package:flutter/material.dart';

class AppTheme {
  static const purple = Color(0xFF3F007D);
  static const lightPurple = Color(0xFFF5F2FF);
  static const yellow = Color(0xFFFFDD45);
  static const text = Color(0xFF1D1D2A);

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: lightPurple,
        colorScheme: ColorScheme.fromSeed(seedColor: purple),
        fontFamily: 'Arial',
        appBarTheme: const AppBarTheme(
          backgroundColor: lightPurple,
          foregroundColor: text,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF0F0FA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFD9D5E5)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFD9D5E5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: purple, width: 1.5),
          ),
        ),
      );
}
