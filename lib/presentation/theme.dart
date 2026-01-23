import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get darkTheme {
    const buttonColor = Color(0xFFFE5D33);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: buttonColor,
      brightness: Brightness.dark,
    ).copyWith(
      primary: buttonColor,
      onPrimary: Colors.white,
    );
    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFFD8EFFD),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFACB8A0),
        foregroundColor: Color(0xFF352029),
      ),
      cardColor: const Color(0xFF2A2A2A),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: Colors.white,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: Colors.white,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: buttonColor,
          side: const BorderSide(color: buttonColor),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: buttonColor,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: buttonColor,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: buttonColor,
        foregroundColor: Colors.white,
      ),
      toggleButtonsTheme: ToggleButtonsThemeData(
        color: buttonColor,
        selectedColor: Colors.white,
        fillColor: buttonColor,
        borderColor: buttonColor,
        selectedBorderColor: buttonColor,
      ),
      useMaterial3: true,
    );
  }
}
