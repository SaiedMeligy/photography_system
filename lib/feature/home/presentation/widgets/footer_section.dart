import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/translations/locale_keys.g.dart';
import 'package:photgraphy_system/admin/core/services/admin_data_service.dart';
import 'package:photgraphy_system/admin/core/models/site_settings.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;
    final settings = AdminDataService.getSiteSettings() ?? SiteSettings();

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
                ? _buildMobile(context, settings)
                : _buildDesktop(context, settings),
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
                    '© ${DateTime.now().year} ${settings.photographerName}. ${LocaleKeys.footer_rights.tr()}',
                    textAlign: isMobile ? TextAlign.center : (context.locale.languageCode == 'ar' ? TextAlign.right : TextAlign.left),
                    style: GoogleFonts.montserrat(
                      fontSize: 11,
                      color: AppTheme.textDim,
                    ),
                  ),
                ),
                if (!isMobile)
                  Text(
                    LocaleKeys.contact_payment_value.tr(),
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

  Widget _buildDesktop(BuildContext context, final settings) {
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
                settings.logoText,
                style: GoogleFonts.dancingScript(
                  fontSize: 40,
                  color: AppTheme.gold,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                settings.photographerTagline.toUpperCase(),
                style: GoogleFonts.montserrat(
                  fontSize: 9,
                  letterSpacing: 0.35,
                  color: AppTheme.textDim,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                settings.footerTagline,
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
              _FooterHeading(LocaleKeys.footer_quick_links.tr()),
              const SizedBox(height: 16),
              _FooterLink(LocaleKeys.nav_home.tr(), () => context.go('/')),
              _FooterLink(LocaleKeys.nav_portfolio.tr(), () => context.go('/portfolio')),
              _FooterLink(LocaleKeys.nav_packages.tr(), () => context.go('/packages')),
              _FooterLink(LocaleKeys.nav_book.tr(), () => context.go('/booking')),
            ],
          ),
        ),
        // Contact
        Expanded(
          child: Column(
            crossAxisAlignment: isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              _FooterHeading(LocaleKeys.footer_contact.tr()),
              const SizedBox(height: 16),
              if (settings.whatsappNumber.isNotEmpty)
                _ContactLink('📱 ${settings.whatsappNumber}', 'https://wa.me/${settings.whatsappNumber}'),
              if (settings.instagramHandle.isNotEmpty)
                _ContactLink('📸 ${settings.instagramHandle}', settings.instagramUrl.isNotEmpty ? settings.instagramUrl : 'https://www.instagram.com/${settings.instagramHandle.replaceAll('@', '')}'),
              if (settings.facebookUrl.isNotEmpty)
                _ContactLink('📘 Facebook', settings.facebookUrl),
              if (settings.locationAddress.isNotEmpty)
                _ContactLink('📍 ${settings.locationAddress}', settings.locationMapsUrl.isNotEmpty ? settings.locationMapsUrl : 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(settings.locationAddress)}'),
              Text(
                '💳 ${LocaleKeys.contact_payment_value.tr()}',
                textAlign: isRtl ? TextAlign.right : TextAlign.left,
                style: GoogleFonts.montserrat(fontSize: 12, color: AppTheme.textDim, height: 2),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobile(BuildContext context, final settings) {
    final isRtl = context.locale.languageCode == 'ar';
    return Column(
      children: [
        Text(
          settings.logoText,
          style: GoogleFonts.dancingScript(
            fontSize: 40,
            color: AppTheme.gold,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          settings.photographerTagline.toUpperCase(),
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
            _FooterLink(LocaleKeys.nav_home.tr(), () => context.go('/')),
            _FooterLink(LocaleKeys.nav_portfolio.tr(), () => context.go('/portfolio')),
            _FooterLink(LocaleKeys.nav_packages.tr(), () => context.go('/packages')),
            _FooterLink(LocaleKeys.nav_book.tr(), () => context.go('/booking')),
          ],
        ),
        const SizedBox(height: 24),
        if (settings.whatsappNumber.isNotEmpty)
          _ContactLink('📱 ${settings.whatsappNumber}', 'https://wa.me/${settings.whatsappNumber}'),
        if (settings.instagramHandle.isNotEmpty)
          _ContactLink('📸 ${settings.instagramHandle}', settings.instagramUrl.isNotEmpty ? settings.instagramUrl : 'https://www.instagram.com/${settings.instagramHandle.replaceAll('@', '')}'),
        if (settings.facebookUrl.isNotEmpty)
          _ContactLink('📘 Facebook', settings.facebookUrl),
        const SizedBox(height: 8),
        if (settings.locationAddress.isNotEmpty)
          _ContactLink('📍 ${settings.locationAddress}', settings.locationMapsUrl.isNotEmpty ? settings.locationMapsUrl : 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(settings.locationAddress)}'),
        const SizedBox(height: 24),
        Text(
          '© ${DateTime.now().year} ${settings.photographerName}. ${LocaleKeys.footer_rights.tr()}',
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
