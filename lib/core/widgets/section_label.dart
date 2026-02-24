import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class SectionLabel extends StatelessWidget {
  final String text;
  const SectionLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 40, height: 1, color: AppTheme.gold.withOpacity(0.6)),
        const SizedBox(width: 12),
        Text(
          text.toUpperCase(),
          style: GoogleFonts.montserrat(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
            color: AppTheme.gold,
          ),
        ),
        const SizedBox(width: 12),
        Container(width: 40, height: 1, color: AppTheme.gold.withOpacity(0.6)),
      ],
    );
  }
}
