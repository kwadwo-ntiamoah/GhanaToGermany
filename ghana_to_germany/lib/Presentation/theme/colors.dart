import 'package:flutter/material.dart';

class GGSwatch {
  // Primary Color
  static const int _primaryValue = 0xFF530031;
  static const MaterialColor primarySwatch = MaterialColor(
    _primaryValue,
    <int, Color>{
      50: Color(0xFFECE5E8), // 10% opacity
      100: Color(0xFFD0A6B6), // 20% opacity
      200: Color(0xFFB47B8B), // 30% opacity
      300: Color(0xFF993F61), // 40% opacity
      400: Color(0xFF7F0039), // 50% opacity
      500: Color(_primaryValue), // 100% opacity
      600: Color(0xFF4B002D), // 80% opacity
      700: Color(0xFF3B0022), // 90% opacity
      800: Color(0xFF2B0017), // 95% opacity
      900: Color(0xFF1C000C), // 99% opacity
    },
  );

  // Secondary Color
  static const int _secondaryValue = 0xFFDA6220;
  static const MaterialColor secondarySwatch = MaterialColor(
    _secondaryValue,
    <int, Color>{
      50: Color(0xFFFFE8D0), // 10% opacity
      100: Color(0xFFFFC1A5), // 20% opacity
      200: Color(0xFFFFA380), // 30% opacity
      300: Color(0xFFFF7E56), // 40% opacity
      400: Color(0xFFFF5E3A), // 50% opacity
      500: Color(_secondaryValue), // 100% opacity
      600: Color(0xFFB84D1A), // 80% opacity
      700: Color(0xFF9B3D15), // 90% opacity
      800: Color(0xFF7E2D10), // 95% opacity
      900: Color(0xFF621C0C), // 99% opacity
    },
  );

  // Text Color
  static const Color textPrimary = Color(0xFF2C2C2E);
  static const Color textSecondary = Color(0xFF3A3A3C);

  // background color
  static const Color light = Colors.white;
  static const Color disabled = Color(0XFFB0BEC5);
}

class AppColors {
  AppColors._();

  static Color primary = GGSwatch.primarySwatch[500]!;
  static Color secondary = GGSwatch.secondarySwatch[500]!;
}