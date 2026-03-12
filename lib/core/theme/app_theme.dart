// lib/core/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';
import 'fonts.dart';

class AppTheme {
  static const Color backgroundColor = Color(0xFFF7F7F7);
  
  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: backgroundColor,
      fontFamily: kArabicFontFamily,
      useMaterial3: true,
      primaryColor: ColorsManager.primaryColor,
      colorScheme: const ColorScheme.light(
        primary: ColorsManager.primaryColor,
        secondary: ColorsManager.secondary500,
        surface: ColorsManager.white,
        onPrimary: ColorsManager.white,
        onSecondary: ColorsManager.black,
        onSurface: ColorsManager.black,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: ColorsManager.black,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: backgroundColor,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      cardTheme: CardThemeData(
        color: ColorsManager.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: ColorsManager.grey100,
      ),
      iconTheme: const IconThemeData(
        color: ColorsManager.black,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: ColorsManager.black),
        bodyMedium: TextStyle(color: ColorsManager.black),
        bodySmall: TextStyle(color: ColorsManager.darkGray),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: ColorsManager.white,
        filled: true,
        hintStyle: const TextStyle(color: ColorsManager.darkGray),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ColorsManager.grey200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ColorsManager.grey200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ColorsManager.black),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ColorsManager.errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ColorsManager.errorColor),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: ColorsManager.white,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: ColorsManager.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}