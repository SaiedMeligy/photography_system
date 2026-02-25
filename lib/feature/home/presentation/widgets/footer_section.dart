import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';
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
                    '© ${DateTime.now().year} iBrahiim Photography. ${'footer_rights'.tr()}',
                    textAlign: isMobile ? TextAlign.center : (context.locale.languageCode == 'ar' ? TextAlign.right : TextAlign.left),
                    style: GoogleFonts.montserrat(
                      fontSize: 11,
                      color: AppTheme.textDim,
                    ),
                  ),
                ),
                if (!isMobile)
                  Text(
                    'contact_payment_value'.tr(),
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
    final isRtl = context.locale.languageCode == 'ar';
    return Row(
      textDirection: isRtl ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Brand
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
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
                'footer_tagline'.tr(),
                textAlign: isRtl ? TextAlign.right : TextAlign.left,
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
            crossAxisAlignment: isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              _FooterHeading('footer_quick_links'.tr()),
              const SizedBox(height: 16),
              _FooterLink('nav_home'.tr(), () => context.go('/')),
              _FooterLink('nav_portfolio'.tr(), () => context.go('/portfolio')),
              _FooterLink('nav_packages'.tr(), () => context.go('/packages')),
              _FooterLink('nav_book'.tr(), () => context.go('/booking')),
            ],
          ),
        ),
        // Contact
        Expanded(
          child: Column(
            crossAxisAlignment: isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              _FooterHeading('footer_contact'.tr()),
              const SizedBox(height: 16),
              _ContactLink('📱 01155699971', 'tel:01155699971'),
              _ContactLink('📸 @HEEMA.GAMAL_PH', 'https://www.instagram.com/heema.gamal_ph'),
              _ContactLink('📍 ${'location_title'.tr()}', 'https://www.google.com/maps/search/?api=1&query=25+%D8%B4%D8%A7%D8%B1%D8%B9+%D8%A7%D9%84%D8%B4%D8%B1%D9%83%D8%A7%D8%AA+%D8%A7%D9%84%D8%B2%D8%A7%D9%88%D9%8A%D8%A9+%D8%A7%D9%84%D8%AD%D9%85%D8%B1%D8%A7%D8%A1+%D8%A7%D9%84%D9%82%D8%A7%D9%87%D8%B1%D8%A9'),
              Text(
                '💳 ${'contact_payment_value'.tr()}',
                textAlign: isRtl ? TextAlign.right : TextAlign.left,
                style: GoogleFonts.montserrat(fontSize: 12, color: AppTheme.textDim, height: 2),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobile(BuildContext context) {
    final isRtl = context.locale.languageCode == 'ar';
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
        const SizedBox(height: 6),
        Text(
          'PHOTOGRAPHY',
          style: GoogleFonts.montserrat(
            fontSize: 9,
            letterSpacing: 0.35,
            color: AppTheme.textDim,
          ),
        ),
        const SizedBox(height: 24),
        // Quick links row
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 24,
          runSpacing: 8,
          children: [
            _FooterLink('nav_home'.tr(), () => context.go('/')),
            _FooterLink('nav_portfolio'.tr(), () => context.go('/portfolio')),
            _FooterLink('nav_packages'.tr(), () => context.go('/packages')),
            _FooterLink('nav_book'.tr(), () => context.go('/booking')),
          ],
        ),
        const SizedBox(height: 24),
        _ContactLink('📱 01155699971   •   📸 @HEEMA.GAMAL_PH', 'https://www.instagram.com/heema.gamal_ph'),
        const SizedBox(height: 8),
        _ContactLink('📍 ${'location_address'.tr()}', 'https://www.google.com/maps/search/?api=1&query=25+%D8%B4%D8%A7%D8%B1%D8%B9+%D8%A7%D9%84%D8%B4%D8%B1%D9%83%D8%A7%D8%AA+%D8%A7%D9%84%D8%B2%D8%A7%D9%88%D9%8A%D8%A9+%D8%A7%D9%84%D8%AD%D9%85%D8%B1%D8%A7%D8%A1+%D8%A7%D9%84%D9%82%D8%A7%D9%87%D8%B1%D8%A9'),
        const SizedBox(height: 24),
        Text(
          '© ${DateTime.now().year} iBrahiim Photography. ${'footer_rights'.tr()}',
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
            fontSize: 10,
            color: AppTheme.textDim,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}

class _ContactLink extends StatelessWidget {
  final String label;
  final String url;
  const _ContactLink(this.label, this.url);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
            fontSize: 11,
            color: AppTheme.textDim,
            height: 1.8,
            decoration: TextDecoration.underline,
            decorationColor: AppTheme.textDim.withOpacity(0.3),
          ),
        ),
      ),
    );
  }
}

class _FooterHeading extends StatelessWidget {
  final String text;
  const _FooterHeading(this.text);

  @override
  Widget build(BuildContext context) {
    final isRtl = context.locale.languageCode == 'ar';
    return Text(
      text.toUpperCase(),
      textAlign: isRtl ? TextAlign.right : TextAlign.left,
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
