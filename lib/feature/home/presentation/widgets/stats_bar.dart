import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_theme.dart';

class StatsBar extends StatelessWidget {
  const StatsBar({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale;
    final stats = [
      ('stat_weddings_value'.tr(), 'stat_weddings'.tr()),
      ('stat_years_value'.tr(),    'stat_years'.tr()),
      ('stat_happy_value'.tr(),    'stat_happy'.tr()),
      ('stat_photos_value'.tr(),   'stat_photos'.tr()),
    ];
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: const Border.symmetric(
          horizontal: BorderSide(color: AppTheme.border),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: isMobile
          ? Wrap(
              alignment: WrapAlignment.center,
              runSpacing: 0,
              children: stats.map((s) => SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: _StatItem(s.$1, s.$2),
              )).toList(),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: stats.asMap().entries.map((e) {
                return Expanded(
                  child: _StatItem(e.value.$1, e.value.$2,
                      showDivider: e.key < stats.length - 1),
                );
              }).toList(),
            ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String number;
  final String label;
  final bool showDivider;

  const _StatItem(this.number, this.label, {this.showDivider = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: [
              Text(
                number,
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 48,
                  fontWeight: FontWeight.w300,
                  color: AppTheme.gold,
                  height: 1,
                ),
              ).animate().fadeIn(duration: 700.ms).slideY(begin: 0.3, end: 0),
              const SizedBox(height: 8),
              Text(
                label.toUpperCase(),
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 9,
                  letterSpacing: 0.25,
                  color: AppTheme.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ).animate().fadeIn(delay: 200.ms, duration: 700.ms),
            ],
          ),
        ),
        if (showDivider)
          PositionedDirectional(
            end: 0,
            top: 20,
            bottom: 20,
            child: Container(
              width: 1,
              color: AppTheme.border,
            ),
          ),
      ],
    );
  }
}
