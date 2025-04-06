import 'package:flutter/material.dart';
import 'package:ghana_to_germany/Presentation/theme/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFonts {
  AppFonts._();

  static const double headingSize = 24.0;
  static const double subheadingSize = 20.0;
  static const double bodySize = 16.0;
  static const double smallSize = 12.0;

  // Font weights
  static const FontWeight bold = FontWeight.bold;
  static const FontWeight normal = FontWeight.w400;

  // Define your Google Fonts styles
  static TextStyle headingStyle = GoogleFonts.leagueSpartan(
    textStyle: const TextStyle(
      fontSize: headingSize,
      fontWeight: bold,
      color: GGSwatch.textPrimary,
    ),
  );

  static TextStyle subheadingStyle = GoogleFonts.leagueSpartan(
    textStyle: const TextStyle(
      fontSize: subheadingSize,
      fontWeight: normal,
      color: GGSwatch.textSecondary,
        letterSpacing: -0.2
    ),
  );

  static TextStyle bodyStyle = GoogleFonts.leagueSpartan(
    textStyle: const TextStyle(
      fontSize: bodySize,
      fontWeight: normal,
      color: GGSwatch.textSecondary,
        letterSpacing: -0.2
    ),
  );

  static TextStyle smallStyle = GoogleFonts.leagueSpartan(
    textStyle: const TextStyle(
      fontSize: smallSize,
      fontWeight: normal,
      color: GGSwatch.primarySwatch,
        letterSpacing: -0.2
    )
  );
}