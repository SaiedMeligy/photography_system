import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Container(
      color: AppTheme.bg,
      child: Column(
        children: [
          // Divider line
          Container(height: 1, color: AppTheme.border),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 24 : 80,
              vertical: 60,
            ),
            child: isMobile
                ? _buildMobile(context)
                : _buildDesktop(context),
          ),

          // Bottom bar
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 24 : 80,
              vertical: 24,
            ),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppTheme.border)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '© ${DateTime.now().year} iBrahiim Photography. All rights reserved.',
                    style: GoogleFonts.montserrat(
                      fontSize: 11,
                      color: AppTheme.textDim,
                    ),
                  ),
                ),
                if (!isMobile)
                  Text(
                    'الحجز عبر انستا أو كاش: 01155699971',
                    style: GoogleFonts.montserrat(
                      fontSize: 11,
                      color: AppTheme.textDim,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Brand
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'iBrahiim',
                style: GoogleFonts.dancingScript(
                  fontSize: 40,
                  color: AppTheme.gold,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'PHOTOGRAPHY',
                style: GoogleFonts.montserrat(
                  fontSize: 9,
                  letterSpacing: 0.35,
                  color: AppTheme.textDim,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'نصور اللحظات مش بس الصور — احنا بنحكي حكايتك للأبد.',
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  color: AppTheme.textDim,
                  height: 1.7,
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        const SizedBox(width: 60),
        // Quick Links
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FooterHeading('Quick Links'),
              const SizedBox(height: 16),
              _FooterLink('Home', () => context.go('/')),
              _FooterLink('Portfolio', () => context.go('/portfolio')),
              _FooterLink('Packages', () => context.go('/packages')),
              _FooterLink('Book a Date', () => context.go('/booking')),
            ],
          ),
        ),
        // Contact
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FooterHeading('Contact'),
              const SizedBox(height: 16),
              Text(
                '📱 01155699971',
                style: GoogleFonts.montserrat(fontSize: 12, color: AppTheme.textDim, height: 2),
              ),
              Text(
                '📸 @HEEMA.GAMALPH',
                style: GoogleFonts.montserrat(fontSize: 12, color: AppTheme.textDim, height: 2),
              ),
              Text(
                '💳 كاش / فودافون كاش / بطاقات',
                style: GoogleFonts.montserrat(fontSize: 12, color: AppTheme.textDim, height: 2),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobile(BuildContext context) {
    return Column(
      children: [
        Text(
          'iBrahiim',
          style: GoogleFonts.dancingScript(
            fontSize: 40,
            color: AppTheme.gold,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '© ${DateTime.now().year} iBrahiim Photography.\nAll rights reserved.',
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(fontSize: 11, color: AppTheme.textDim, height: 1.6),
        ),
      ],
    );
  }
}

class _FooterHeading extends StatelessWidget {
  final String text;
  const _FooterHeading(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: GoogleFonts.montserrat(
        fontSize: 9,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
        color: AppTheme.textMuted,
      ),
    );
  }
}

class _FooterLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _FooterLink(this.label, this.onTap);

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            widget.label,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              color: _hover ? AppTheme.gold : AppTheme.textDim,
            ),
          ),
        ),
      ),
    );
  }
}
