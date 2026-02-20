import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF2A2F6A);
  static const Color secondaryColor = Color(0xFFE91E63);
  static const Color accentColor = Color(0xFF6A1B9A);
  static const Color backgroundColor = Color(0xFFF8F9FD); 
  static const Color surfaceColor = Colors.white;
  static const Color errorColor = Color(0xFFE53935);
  static const Color successColor = Color(0xFF43A047);
  
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2A2F6A), Color(0xFF3F4697)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient yonoGradient = LinearGradient(
    colors: [Color(0xFF212555), Color(0xFF6A1B9A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFE91E63), Color(0xFFC2185B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shadows
  static List<BoxShadow> get premiumShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  // Text Styles
  static TextStyle get displayLarge => GoogleFonts.outfit(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );

  static TextStyle get titleLarge => GoogleFonts.outfit(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: primaryColor,
  );

  static TextStyle get bodyLarge => GoogleFonts.outfit(
    fontSize: 16,
    color: Colors.grey[800],
  );

  static TextStyle get labelMedium => GoogleFonts.outfit(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.grey[600],
  );

  // Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      fontFamily: GoogleFonts.outfit().fontFamily,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        error: errorColor,
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      useMaterial3: true,
    );
  }
}
