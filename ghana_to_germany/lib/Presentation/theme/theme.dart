import 'package:flutter/material.dart';
import 'package:ghana_to_germany/Presentation/theme/colors.dart';
import 'package:ghana_to_germany/Presentation/theme/fonts.dart';

class AppTheme {
  static ThemeData theme(BuildContext context) {
    return ThemeData(
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: GGSwatch.light,
      textSelectionTheme: const TextSelectionThemeData(
        selectionColor: GGSwatch.disabled, // The color of the text selection highlight
      ),
      useMaterial3: true,
      textTheme: TextTheme(
          displayLarge: AppFonts.headingStyle.copyWith(
              fontSize: AppFonts.headingSize * getTextScaleFactor(context)),
          displayMedium: AppFonts.subheadingStyle.copyWith(
              fontSize: AppFonts.subheadingSize * getTextScaleFactor(context)),
          bodyLarge: AppFonts.bodyStyle.copyWith(
              fontSize: AppFonts.bodySize * getTextScaleFactor(context)),
          bodyMedium: AppFonts.smallStyle.copyWith(
              fontSize: AppFonts.smallSize * getTextScaleFactor(context))),
    );
  }

  static double getTextScaleFactor(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth >= 600) {
      // Assuming 600px is the breakpoint for tablets
      return 1.5; // Scale factor for tablets
    }

    return 1.0; // Scale factor for normal screens
  }
}
