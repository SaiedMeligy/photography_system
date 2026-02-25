import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/section_label.dart';
import '../../../../core/widgets/gold_button.dart';
import '../../../home/presentation/widgets/footer_section.dart';

class PackagesScreen extends StatelessWidget {
  const PackagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    final isRtl = context.locale.languageCode == 'ar';

    // Package data — strings come from translation keys
    final packages = [
      _Package(
        tier: 'pkg_1_tier',
        name: 'pkg_1_name',
        duration: 'pkg_1_duration',
        price: '2500',
        features: [
          'pkg_feat_session',
          'pkg_feat_album',
          'pkg_feat_tableau_30_40',
          'pkg_feat_flash',
        ],
        featured: false,
      ),
      _Package(
        tier: 'pkg_2_tier',
        name: 'pkg_2_name',
        duration: 'pkg_2_duration',
        price: '3500',
        features: [
          'pkg_feat_session',
          'pkg_feat_hall',
          'pkg_feat_album',
          'pkg_feat_tableau_40_50',
          'pkg_feat_flash',
        ],
        featured: true,
      ),
      _Package(
        tier: 'pkg_3_tier',
        name: 'pkg_3_name',
        duration: 'pkg_3_duration',
        price: '4000',
        features: [
          'pkg_feat_prep',
          'pkg_feat_hall',
          'pkg_feat_album',
          'pkg_feat_tableau_70_50',
          'pkg_feat_flash',
        ],
        featured: false,
      ),
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          // ── Hero
          const _PackagesHero(),

          // ── Packages grid
          Container(
            color: AppTheme.bg,
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 80,
              vertical: 100,
            ),
            child: Column(
              children: [
                SectionLabel(text: 'section_packages'.tr()),
                const SizedBox(height: 24),
                Text(
                  'packages_subtitle'.tr(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    color: AppTheme.textMuted,
                  ),
                ),
                const SizedBox(height: 60),

                // ── Cards
                isMobile
                    ? Column(
                        children: [
                          _PackageCard(package: packages[0], delay: 0),
                          const SizedBox(height: 3),
                          _PackageCard(
                              package: packages[1], delay: 150, featured: true),
                          const SizedBox(height: 3),
                          _PackageCard(package: packages[2], delay: 300),
                        ],
                      )
                    : IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child:
                                  _PackageCard(package: packages[0], delay: 0),
                            ),
                            const SizedBox(width: 3),
                            Expanded(
                              child: _PackageCard(
                                  package: packages[1],
                                  delay: 150,
                                  featured: true),
                            ),
                            const SizedBox(width: 3),
                            Expanded(
                              child: _PackageCard(
                                  package: packages[2], delay: 300),
                            ),
                          ],
                        ),
                      ),

                const SizedBox(height: 70),
                const _ExtrasSection(),
                const SizedBox(height: 40),
                const _NotesSection(),
              ],
            ),
          ),

          const FooterSection(),
        ],
      ),
    );
  }
}

// ─── Hero ──────────────────────────────────────────────────────
class _PackagesHero extends StatelessWidget {
  const _PackagesHero();

  @override
  Widget build(BuildContext context) {
    context.locale; // Listen for changes
    return Container(
      height: 340,
      color: AppTheme.surface,
      child: Stack(
        children: [
          // Decorative circles — position-agnostic (decorative only)
          Positioned(
            left: -40,
            top: -40,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: AppTheme.gold.withOpacity(0.06), width: 80),
              ),
            ),
          ),
          Positioned(
            right: -60,
            bottom: -60,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: AppTheme.gold.withOpacity(0.04), width: 100),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 90),
                SectionLabel(text: 'section_packages'.tr()),
                const SizedBox(height: 20),
                Text(
                  'packages_title_1'.tr(),
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 62,
                    fontWeight: FontWeight.w300,
                    color: AppTheme.textPrimary,
                  ),
                ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2, end: 0),
                Text(
                  'packages_title_2'.tr(),
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 36,
                    fontWeight: FontWeight.w300,
                    fontStyle: FontStyle.italic,
                    color: AppTheme.gold,
                  ),
                ).animate().fadeIn(delay: 200.ms, duration: 700.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Package Card ──────────────────────────────────────────────
class _PackageCard extends StatefulWidget {
  final _Package package;
  final int delay;
  final bool featured;

  const _PackageCard({
    required this.package,
    this.delay = 0,
    this.featured = false,
  });

  @override
  State<_PackageCard> createState() => _PackageCardState();
}

class _PackageCardState extends State<_PackageCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final featured = widget.featured || widget.package.featured;
    final isRtl = context.locale.languageCode == 'ar';

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
        transform:
            Matrix4.translationValues(0, (_hover && !featured) ? -8 : 0, 0),
        decoration: BoxDecoration(
          color: featured ? AppTheme.surface2 : AppTheme.surface,
          border: Border(
            top: BorderSide(
              color:
                  featured || _hover ? AppTheme.gold : Colors.transparent,
              width: 3,
            ),
            left: BorderSide(color: AppTheme.border),
            right: BorderSide(color: AppTheme.border),
            bottom: BorderSide(color: AppTheme.border),
          ),
          boxShadow: (_hover || featured)
              ? [
                  BoxShadow(
                    color: AppTheme.gold.withOpacity(0.1),
                    blurRadius: 40,
                    spreadRadius: 0,
                  )
                ]
              : [],
        ),
        clipBehavior: Clip.hardEdge,
        padding: const EdgeInsets.all(36),
        child: Column(
          // stretch = content fills full width, aligns to reading direction
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Badge
            if (featured) ...[
              Align(
                alignment: isRtl
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  color: AppTheme.gold,
                  child: Text(
                    'package_most_popular'.tr().toUpperCase(),
                    style: GoogleFonts.montserrat(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                      color: AppTheme.bg,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // ── Tier label
            Text(
              widget.package.tier.tr().toUpperCase(),
              textAlign: isRtl ? TextAlign.right : TextAlign.left,
              style: GoogleFonts.montserrat(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
                color: AppTheme.gold,
              ),
            ),
            const SizedBox(height: 8),

            // ── Name
            Text(
              widget.package.name.tr(),
              textAlign: isRtl ? TextAlign.right : TextAlign.left,
              style: GoogleFonts.cormorantGaramond(
                fontSize: 36,
                fontWeight: FontWeight.w300,
                color: AppTheme.textPrimary,
                height: 1.2,
              ),
            ),

            // ── Duration row
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 20,
                    height: 1,
                    color: AppTheme.gold.withOpacity(0.5),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.package.duration.tr(),
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: AppTheme.textMuted,
                      letterSpacing: 0.15,
                    ),
                  ),
                ],
              ),
            ),

            // ── Price
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                crossAxisAlignment:CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: widget.package.price,
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 56,
                            fontWeight: FontWeight.w300,
                            color: AppTheme.gold,
                            height: 1,
                          ),
                        ),
                        TextSpan(
                          text: ' LE',
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 22,
                            color: AppTheme.gold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isRtl ? 'جنيه مصري' : 'LE',
                    style: GoogleFonts.montserrat(
                      fontSize: 10,
                      color: AppTheme.textDim,
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),
            ),

            // ── Divider
            Container(height: 1, color: AppTheme.border),
            const SizedBox(height: 28),

            // ── Features list
            ...widget.package.features.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 18,
                        height: 18,
                        margin: const EdgeInsets.only(top: 2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.goldDim,
                          border: Border.all(color: AppTheme.gold),
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 10,
                          color: AppTheme.gold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          f.tr(),
                          textAlign: isRtl ? TextAlign.right : TextAlign.left,
                          style: GoogleFonts.montserrat(
                            fontSize: 13,
                            color: AppTheme.textMuted,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),

            const SizedBox(height: 40),

            // ── CTA
            Builder(
              builder: (ctx) => GoldButton(
                label: 'package_book_btn'.tr(),
                onTap: () => ctx.go('/booking'),
                outline: !featured,
                icon: Icons.calendar_today_outlined,
              ),
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(
            delay: Duration(milliseconds: widget.delay),
            duration: 700.ms,
          )
          .slideY(begin: 0.1, end: 0),
    );
  }
}

// ─── Extras Section ────────────────────────────────────────────
class _ExtrasSection extends StatelessWidget {
  const _ExtrasSection();

  static const List<Map<String, String>> _extras = [
    {'name': 'extra_session_only', 'duration': 'extra_unit_hour', 'price': '1500'},
    {'name': 'extra_hall_only', 'duration': 'extra_unit_hours', 'price': '1000'},
    {
      'name': 'extra_video_session_prep',
      'duration': '',
      'price': '2000'
    },
    {
      'name': 'extra_video_session_hall',
      'duration': 'extra_unit_half_day',
      'price': '2500'
    },
    {
      'name': 'extra_video_full_day',
      'duration': 'extra_unit_full_day',
      'price': '3000'
    },
    {'name': 'extra_reel_session_prep', 'duration': '', 'price': '1000'},
    {'name': 'extra_reel_full_day', 'duration': 'extra_unit_full_day', 'price': '1500'},
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;
    final isRtl = context.locale.languageCode == 'ar';

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border.all(color: AppTheme.border),
      ),
      padding: const EdgeInsets.all(48),
      child: Column(
        crossAxisAlignment:  CrossAxisAlignment.start,
        children: [
          RichText(
            textAlign: isRtl ? TextAlign.right : TextAlign.left,
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${'extras_title_1'.tr()} ',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 36,
                    fontWeight: FontWeight.w300,
                    color: AppTheme.textPrimary,
                  ),
                ),
                TextSpan(
                  text: 'extras_title_2'.tr(),
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 36,
                    fontWeight: FontWeight.w300,
                    fontStyle: FontStyle.italic,
                    color: AppTheme.gold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'extras_subtitle'.tr(),
            textAlign: isRtl ? TextAlign.right : TextAlign.left,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 32),
          isMobile
              ? Column(
                  children: _extras
                      .map((e) => Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: _ExtraItem(data: e),
                          ))
                      .toList(),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 3,
                    mainAxisSpacing: 3,
                    childAspectRatio: 4,
                  ),
                  itemCount: _extras.length,
                  itemBuilder: (ctx, i) => _ExtraItem(data: _extras[i]),
                ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms, duration: 700.ms);
  }
}

// ─── Extra Item ────────────────────────────────────────────────
class _ExtraItem extends StatefulWidget {
  final Map<String, String> data;
  const _ExtraItem({required this.data});

  @override
  State<_ExtraItem> createState() => _ExtraItemState();
}

class _ExtraItemState extends State<_ExtraItem> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final isRtl = context.locale.languageCode == 'ar';

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(
          horizontal: _hover ? 28 : 20,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: AppTheme.bg,
          // RTL: gold bar on the right (end); LTR: left (start)
          border: isRtl
              ? Border(
                  right: BorderSide(
                    color: _hover ? AppTheme.gold : Colors.transparent,
                    width: 2,
                  ),
                )
              : Border(
                  left: BorderSide(
                    color: _hover ? AppTheme.gold : Colors.transparent,
                    width: 2,
                  ),
                ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    (widget.data['name'] ?? '').tr(),
                    textAlign: isRtl ? TextAlign.right : TextAlign.left,
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      color: AppTheme.textMuted,
                    ),
                  ),
                  if ((widget.data['duration'] ?? '').isNotEmpty)
                    Text(
                      (widget.data['duration']!).tr(),
                      style: GoogleFonts.montserrat(
                        fontSize: 10,
                        color: AppTheme.textDim,
                        letterSpacing: 0.1,
                      ),
                    ),
                ],
              ),
            ),
            Text(
              '${widget.data['price']} LE',
              style: GoogleFonts.cormorantGaramond(
                fontSize: 22,
                fontWeight: FontWeight.w300,
                color: AppTheme.gold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Notes Section ─────────────────────────────────────────────
class _NotesSection extends StatelessWidget {
  const _NotesSection();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;
    final isRtl = context.locale.languageCode == 'ar';

    final notes = [
      'note_delivery'.tr(),
      'note_cancellation'.tr(),
      'note_punctuality'.tr(),
      'note_location_fees'.tr(),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
      decoration: BoxDecoration(
        color: AppTheme.goldDim,
        // RTL: accent bar on right (start of reading), LTR: left
        border: isRtl
            ? const Border(
                right: BorderSide(color: AppTheme.gold, width: 3),
              )
            : const Border(
                left: BorderSide(color: AppTheme.gold, width: 3),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'important_notes'.tr(),
            textAlign: isRtl ? TextAlign.right : TextAlign.left,
            style: GoogleFonts.montserrat(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.25,
              color: AppTheme.gold,
            ),
          ),
          const SizedBox(height: 16),
          isMobile
              ? Column(
                  children: notes
                      .map((n) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '— ',
                                  style: GoogleFonts.montserrat(
                                      color: AppTheme.gold, fontSize: 13),
                                ),
                                Expanded(
                                  child: Text(
                                    n,
                                    textAlign: isRtl
                                        ? TextAlign.right
                                        : TextAlign.left,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 13,
                                      color: AppTheme.textMuted,
                                      height: 1.6,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                )
              : GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 10,
                  childAspectRatio: 6,
                  children: notes
                      .map((n) => Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '— ',
                                style: GoogleFonts.montserrat(
                                    color: AppTheme.gold, fontSize: 13),
                              ),
                              Expanded(
                                child: Text(
                                  n,
                                  textAlign: isRtl
                                      ? TextAlign.right
                                      : TextAlign.left,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 13,
                                    color: AppTheme.textMuted,
                                    height: 1.6,
                                  ),
                                ),
                              ),
                            ],
                          ))
                      .toList(),
                ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms, duration: 700.ms);
  }
}

// ─── Data Class ────────────────────────────────────────────────
class _Package {
  final String tier;
  final String name;
  final String duration;
  final String price;
  final List<String> features;
  final bool featured;

  const _Package({
    required this.tier,
    required this.name,
    required this.duration,
    required this.price,
    required this.features,
    required this.featured,
  });
}
