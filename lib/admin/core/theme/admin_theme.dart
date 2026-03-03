import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Admin dashboard visual theme — dark, premium, gold accents.
class AdminTheme {
  AdminTheme._();

  // ─── Colors ───────────────────────────────────────────────────
  static const bg = Color(0xFF0D0D0F);
  static const surface = Color(0xFF141416);
  static const surfaceAlt = Color(0xFF1A1A1D);
  static const border = Color(0xFF2A2A2D);
  static const borderLight = Color(0xFF3A3A3D);

  static const gold = Color(0xFFD4A853);
  static const goldDim = Color(0x1AD4A853);
  static const goldLight = Color(0xFFE8C47A);

  static const textPrimary = Color(0xFFF5F0E8);
  static const textMuted = Color(0xFF9A9A9A);
  static const textDim = Color(0xFF5A5A5A);

  static const success = Color(0xFF2ECC71);
  static const successDim = Color(0x1A2ECC71);
  static const warning = Color(0xFFF39C12);
  static const warningDim = Color(0x1AF39C12);
  static const danger = Color(0xFFE74C3C);
  static const dangerDim = Color(0x1AE74C3C);
  static const info = Color(0xFF3498DB);
  static const infoDim = Color(0x1A3498DB);

  static const sidebarWidth = 260.0;
  static const topBarHeight = 64.0;

  // ─── Theme ────────────────────────────────────────────────────
  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bg,
        colorScheme: const ColorScheme.dark(
          surface: surface,
          primary: gold,
          secondary: goldLight,
        ),
        dividerColor: border,
        cardColor: surface,
        textTheme: GoogleFonts.montserratTextTheme(
          const TextTheme(
            bodyMedium: TextStyle(color: textMuted),
            bodySmall: TextStyle(color: textDim),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surfaceAlt,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: gold),
          ),
          labelStyle: const TextStyle(color: textMuted),
          hintStyle: const TextStyle(color: textDim),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: gold,
            foregroundColor: bg,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            textStyle: GoogleFonts.montserrat(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              letterSpacing: 0.1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: gold,
            side: const BorderSide(color: border),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            textStyle: GoogleFonts.montserrat(fontSize: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: surfaceAlt,
          selectedColor: goldDim,
          labelStyle: GoogleFonts.montserrat(fontSize: 11, color: textMuted),
          side: const BorderSide(color: border),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith(
              (s) => s.contains(WidgetState.selected) ? gold : textDim),
          trackColor: WidgetStateProperty.resolveWith(
              (s) => s.contains(WidgetState.selected) ? goldDim : border),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: surfaceAlt,
          contentTextStyle: GoogleFonts.montserrat(color: textPrimary, fontSize: 13),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      );

  // ─── Text Styles ──────────────────────────────────────────────
  static TextStyle headline(double size, {FontWeight weight = FontWeight.w400}) => 
      GoogleFonts.cormorantGaramond(
        fontSize: size,
        fontWeight: weight,
        color: textPrimary,
      );

  static TextStyle label({double size = 11, Color? color, FontWeight weight = FontWeight.w600}) =>
      GoogleFonts.montserrat(
        fontSize: size,
        fontWeight: weight,
        letterSpacing: 0.2,
        color: color ?? textMuted,
      );

  static TextStyle body({double size = 13, Color? color, FontWeight weight = FontWeight.w400}) =>
      GoogleFonts.montserrat(
        fontSize: size,
        color: color ?? textMuted,
        fontWeight: weight,
      );
}
