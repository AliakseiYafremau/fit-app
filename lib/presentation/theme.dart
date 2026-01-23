import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    const buttonColor = Color(0xFFFE5D33);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: buttonColor,
      brightness: Brightness.dark,
    ).copyWith(
      primary: buttonColor,
      onPrimary: Colors.white,
      surface: const Color(0xFF352029),
      onSurface: Colors.white,
      outline: buttonColor,
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

  static ThemeData get darkTheme {
    const backgroundColor = Colors.black;
    const foregroundColor = Colors.white;
    const solidButtonColor = Colors.white;
    const onSolidButtonColor = Colors.black;
    const outlineColor = Colors.white;
    const colorScheme = ColorScheme.dark(
      primary: solidButtonColor,
      onPrimary: onSolidButtonColor,
      secondary: solidButtonColor,
      onSecondary: onSolidButtonColor,
      surface: backgroundColor,
      onSurface: foregroundColor,
      outline: outlineColor,
    );
    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
      ),
      cardColor: backgroundColor,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: solidButtonColor,
          foregroundColor: onSolidButtonColor,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: solidButtonColor,
          foregroundColor: onSolidButtonColor,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: outlineColor,
          side: const BorderSide(color: outlineColor),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: foregroundColor,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: foregroundColor,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: outlineColor, width: 2),
        ),
      ),
      toggleButtonsTheme: ToggleButtonsThemeData(
        color: foregroundColor,
        selectedColor: onSolidButtonColor,
        fillColor: solidButtonColor,
        borderColor: outlineColor,
        selectedBorderColor: outlineColor,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: backgroundColor,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: outlineColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: outlineColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: outlineColor, width: 2),
        ),
        hintStyle: TextStyle(color: Color(0xFFBDBDBD)),
      ),
      iconTheme: const IconThemeData(color: foregroundColor),
      dividerColor: outlineColor,
      textTheme: ThemeData.dark()
          .textTheme
          .apply(bodyColor: foregroundColor, displayColor: foregroundColor),
      useMaterial3: true,
    );
  }
}
