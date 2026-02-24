import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── Theme Notifier (global toggle) ───────────────────────────
final themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.dark);

class AppTheme {
  // ─── Shared Gold Palette ──────────────────────────────────────
  static const Color gold      = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFE8CC6A);
  static const Color goldDim   = Color(0x26D4AF37);
  static const Color rose      = Color(0xFFC8A07A);

  // ─── Dark Palette ─────────────────────────────────────────────
  static const Color darkBg          = Color(0xFF0A0A0A);
  static const Color darkBgAlt       = Color(0xFF111111);
  static const Color darkSurface     = Color(0xFF1A1A1A);
  static const Color darkSurface2    = Color(0xFF222222);
  static const Color darkTextPrimary = Color(0xFFF0ECE4);
  static const Color darkTextMuted   = Color(0xFF9A9490);
  static const Color darkTextDim     = Color(0xFF6A6660);
  static const Color darkBorder      = Color(0x33D4AF37);

  // ─── Backward-compat aliases (dark values, used by existing widgets) ──
  static const Color bg          = darkBg;
  static const Color bgAlt       = darkBgAlt;
  static const Color surface     = darkSurface;
  static const Color surface2    = darkSurface2;
  static const Color textPrimary = darkTextPrimary;
  static const Color textMuted   = darkTextMuted;
  static const Color textDim     = darkTextDim;
  static const Color border      = darkBorder;


  // ─── Light Palette ────────────────────────────────────────────
  static const Color lightBg          = Color(0xFFFAF8F5);
  static const Color lightBgAlt       = Color(0xFFF0EDE7);
  static const Color lightSurface     = Color(0xFFFFFFFF);
  static const Color lightSurface2    = Color(0xFFF5F2EC);
  static const Color lightTextPrimary = Color(0xFF1A1410);
  static const Color lightTextMuted   = Color(0xFF5A5248);
  static const Color lightTextDim     = Color(0xFF8A8278);
  static const Color lightBorder      = Color(0x44D4AF37);


  // ─── Dark Theme ───────────────────────────────────────────────

  static ThemeData get darkTheme => _buildTheme(Brightness.dark);

  // ─── Light Theme ──────────────────────────────────────────────
  static ThemeData get lightTheme => _buildTheme(Brightness.light);

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final bg          = isDark ? darkBg          : lightBg;
    final surface     = isDark ? darkSurface     : lightSurface;
    final textPrimary = isDark ? darkTextPrimary : lightTextPrimary;
    final textMuted   = isDark ? darkTextMuted   : lightTextMuted;
    final textDim     = isDark ? darkTextDim     : lightTextDim;
    final border      = isDark ? darkBorder      : lightBorder;

    return ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: bg,
      primaryColor: gold,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: gold,
        secondary: rose,
        surface: surface,
        error: const Color(0xFFCF6679),
        onPrimary: bg,
        onSecondary: bg,
        onSurface: textPrimary,
        onError: Colors.white,
      ),
      textTheme: GoogleFonts.montserratTextTheme(
        (isDark ? ThemeData.dark() : ThemeData.light()).textTheme.copyWith(
          displayLarge: GoogleFonts.cormorantGaramond(
            fontSize: 82,    // was 72
            fontWeight: FontWeight.w300,
            color: textPrimary,
            letterSpacing: -1,
          ),
          displayMedium: GoogleFonts.cormorantGaramond(
            fontSize: 60,    // was 52
            fontWeight: FontWeight.w300,
            color: textPrimary,
          ),
          displaySmall: GoogleFonts.cormorantGaramond(
            fontSize: 44,    // was 36
            fontWeight: FontWeight.w300,
            color: textPrimary,
          ),
          headlineLarge: GoogleFonts.cormorantGaramond(
            fontSize: 34,    // was 28
            fontWeight: FontWeight.w400,
            color: textPrimary,
          ),
          headlineMedium: GoogleFonts.montserrat(
            fontSize: 22,    // was 20
            fontWeight: FontWeight.w500,
            color: textPrimary,
          ),
          bodyLarge: GoogleFonts.montserrat(
            fontSize: 18,    // was 16
            fontWeight: FontWeight.w300,
            color: textMuted,
            height: 1.8,
          ),
          bodyMedium: GoogleFonts.montserrat(
            fontSize: 16,    // was 14
            fontWeight: FontWeight.w300,
            color: textMuted,
            height: 1.7,
          ),
          labelSmall: GoogleFonts.montserrat(
            fontSize: 12,    // was 10
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
            color: gold,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: gold, width: 1.5),
        ),
        labelStyle: GoogleFonts.montserrat(color: textMuted, fontSize: 14),
        hintStyle: GoogleFonts.montserrat(color: textDim, fontSize: 15),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: gold,
          foregroundColor: bg,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          textStyle: GoogleFonts.montserrat(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          side: BorderSide(color: border),
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          textStyle: GoogleFonts.montserrat(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      dividerColor: border,
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: border),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.cormorantGaramond(
          fontSize: 26,
          color: textPrimary,
          fontWeight: FontWeight.w400,
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),
    );
  }
}
