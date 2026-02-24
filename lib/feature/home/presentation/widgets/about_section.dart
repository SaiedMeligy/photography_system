import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/section_label.dart';
import '../../../../core/constants/image_assets.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
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
    return SizedBox(
      height: 550,
      child: Stack(
        children: [
          // Main image
          Positioned(
            right: 0,
            top: 0,
            child: ClipRect(
              child: SizedBox(
                width: MediaQuery.of(context).size.width < 900
                    ? double.infinity
                    : MediaQuery.of(context).size.width * 0.3,
                height: 420,
                child: Image.asset(
                  portfolioImages[10],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 900.ms)
              .slideX(begin: 0.1, end: 0),

          // Second image
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.bg, width: 4),
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width < 900 ? 200 : 240,
                height: 280,
                child: Image.asset(
                  portfolioImages[25],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
              .animate()
              .fadeIn(delay: 300.ms, duration: 900.ms)
              .slideX(begin: -0.1, end: 0),

          // Gold badge
          Positioned(
            right: 20,
            bottom: 60,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              color: AppTheme.gold,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '5+',
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 40,
                      fontWeight: FontWeight.w300,
                      color: AppTheme.bg,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'YEARS\nEXPERIENCE',
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
        ],
      ),
    );
  }
}

class _AboutContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel(text: 'About Me'),
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
                text: 'The Artist\n',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 52,
                  fontWeight: FontWeight.w300,
                  color: AppTheme.textPrimary,
                  height: 1.2,
                ),
              ),
              TextSpan(
                text: 'Behind the Lens',
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
          'ببساطة، أنا مؤمن إن كل فرح له روح خاصة — وكل لحظة فيه حكاية. '
          'من أول ضحكة للعروسة لما بتشوف نفسها، لحد آخر رقصة في الليل.',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            color: AppTheme.textMuted,
            height: 1.9,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'بصورة ببساطة أكثر من 200 فرح، وكل صورة كانت من قلبي. '
          'هدفي إنك من غير ما تقلق أي حاجة — تلاقي نفسك في كل صورة.',
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
            border: const Border(
              left: BorderSide(color: AppTheme.gold, width: 3),
            ),
            color: AppTheme.goldDim,
          ),
          child: Text(
            '"بصور اللحظات، مش بس الصور"',
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
            _Stat('01155699971', 'Phone / WhatsApp'),
            _Stat('@HEEMA.GAMALPH', 'Instagram & Facebook'),
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
