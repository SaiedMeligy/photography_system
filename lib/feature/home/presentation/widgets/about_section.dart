import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/section_label.dart';
import '../../../../core/constants/image_assets.dart';
import '../../../../core/translations/locale_keys.g.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return Container(
      color: AppTheme.bg,
      padding: EdgeInsets.symmetric(
        vertical: 100,
        horizontal: isMobile ? 24 : 80,
      ),
      child: isMobile
          ? _buildMobile(context)
          : _buildDesktop(context),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Images stack
        Expanded(child: _ImagesStack()),
        const SizedBox(width: 80),
        // Content
        Expanded(child: _AboutContent()),
      ],
    );
  }

  Widget _buildMobile(BuildContext context) {
    return Column(
      children: [
        _ImagesStack(),
        const SizedBox(height: 50),
        _AboutContent(),
      ],
    );
  }
}

class _ImagesStack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.locale;
    final isMobile = MediaQuery.of(context).size.width < 900;
    
    return SizedBox(
      height: 550,
      child: Stack(
        children: [
          // Main image
          PositionedDirectional(
            end: 0,
            top: 0,
            start: isMobile ? 40 : null, // Give it some offset on mobile instead of full width
            child: RepaintBoundary(
              child: ClipRect(
                child: SizedBox(
                  width: isMobile
                      ? null // Constraints from Positioned
                      : MediaQuery.of(context).size.width * 0.3,
                  height: 420,
                  child: Image.asset(
                    portfolioImages[10],
                    fit: BoxFit.cover,
                    cacheWidth: 800,
                  ),
                ),
              ),
            )
                .animate()
                .fadeIn(duration: 900.ms)
                .slideX(begin: 0.1, end: 0),
          ),

          // Second image
          PositionedDirectional(
            start: 0,
            bottom: 0,
            child: RepaintBoundary(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.bg, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: isMobile ? 180 : 240,
                  height: 280,
                  child: Image.asset(
                    portfolioImages[25],
                    fit: BoxFit.cover,
                    cacheWidth: 500,
                  ),
                ),
              ),
            )
                .animate()
                .fadeIn(delay: 300.ms, duration: 900.ms)
                .slideX(begin: -0.1, end: 0),
          ),

          // Gold badge
          PositionedDirectional(
            end: isMobile ? 10 : 20,
            bottom: isMobile ? 80 : 60,
            child: RepaintBoundary(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                color: AppTheme.gold,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      LocaleKeys.stat_years_value.tr(),
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 40,
                        fontWeight: FontWeight.w300,
                        color: AppTheme.bg,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      LocaleKeys.stat_years.tr().toUpperCase(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.15,
                        color: AppTheme.bg,
                      ),
                    ),
                  ],
                ),
              ),
            )
                .animate()
                .fadeIn(delay: 500.ms, duration: 700.ms)
                .scale(begin: const Offset(0.8, 0.8)),
          ),
        ],
      ),
    );
  }
}

class _AboutContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.locale;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(text: LocaleKeys.section_about.tr()),
        const SizedBox(height: 20),
        Text(
          'iBrahiim',
          style: GoogleFonts.dancingScript(
            fontSize: 36,
            color: AppTheme.gold,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '${LocaleKeys.about_title_1.tr()}\n',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 52,
                  fontWeight: FontWeight.w300,
                  color: AppTheme.textPrimary,
                  height: 1.2,
                ),
              ),
              TextSpan(
                text: LocaleKeys.about_title_2.tr(),
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 52,
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.italic,
                  color: AppTheme.gold,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        Text(
          LocaleKeys.about_p1.tr(),
          style: GoogleFonts.montserrat(
            fontSize: 16,
            color: AppTheme.textMuted,
            height: 1.9,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          LocaleKeys.about_p2.tr(),
          style: GoogleFonts.montserrat(
            fontSize: 16,
            color: AppTheme.textMuted,
            height: 1.9,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 36),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: BorderDirectional(
              start: const BorderSide(color: AppTheme.gold, width: 3),
            ),
            color: AppTheme.goldDim,
          ),
          child: Text(
            '"${LocaleKeys.footer_tagline.tr()}"',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 22,
              fontStyle: FontStyle.italic,
              color: AppTheme.gold,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(height: 36),
        Wrap(
          spacing: 40,
          runSpacing: 20,
          children: [
            _Stat('01155699971', LocaleKeys.contact_phone_label.tr()),
            _Stat('@HEEMA.GAMAL_PH', LocaleKeys.contact_social_label.tr()),
          ],
        ),
      ],
    )
        .animate()
        .fadeIn(delay: 200.ms, duration: 800.ms)
        .slideX(begin: 0.1, end: 0);
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  const _Stat(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.montserrat(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 10,
            color: AppTheme.textDim,
            letterSpacing: 0.15,
          ),
        ),
      ],
    );
  }
}
