import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/section_label.dart';
import '../../../../core/widgets/gold_button.dart';
import '../../../home/presentation/widgets/footer_section.dart';

class PackagesScreen extends StatelessWidget {
  const PackagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Hero
          _PackagesHero(),

          // Packages grid
          Container(
            color: AppTheme.bg,
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 24 : 80,
              vertical: 100,
            ),
            child: Column(
              children: [
                const SectionLabel(text: 'Investment'),
                const SizedBox(height: 20),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Choose Your\n',
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: isMobile ? 36 : 52,
                          fontWeight: FontWeight.w300,
                          color: AppTheme.textPrimary,
                          height: 1.2,
                        ),
                      ),
                      TextSpan(
                        text: 'Perfect Package',
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: isMobile ? 36 : 52,
                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.italic,
                          color: AppTheme.gold,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'كل باكدج مصمم عشان يغطي احتياجات مختلفة — اختار اللي يناسبك',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    color: AppTheme.textMuted,
                  ),
                ),
                const SizedBox(height: 70),

                // Package cards
                isMobile
                    ? Column(
                        children: [
                          _PackageCard(
                            package: _packages[0],
                            delay: 0,
                          ),
                          const SizedBox(height: 3),
                          _PackageCard(
                            package: _packages[1],
                            delay: 150,
                            featured: true,
                          ),
                          const SizedBox(height: 3),
                          _PackageCard(
                            package: _packages[2],
                            delay: 300,
                          ),
                        ],
                      )
                    : IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: _PackageCard(package: _packages[0], delay: 0),
                            ),
                            const SizedBox(width: 3),
                            Expanded(
                              child: _PackageCard(
                                  package: _packages[1],
                                  delay: 150,
                                  featured: true),
                            ),
                            const SizedBox(width: 3),
                            Expanded(
                              child: _PackageCard(package: _packages[2], delay: 300),
                            ),
                          ],
                        ),
                      ),

                const SizedBox(height: 70),

                // Extras
                _ExtrasSection(),

                const SizedBox(height: 40),

                // Notes
                _NotesSection(),
              ],
            ),
          ),

          const FooterSection(),
        ],
      ),
    );
  }

  // Package data from the price list image
  static final List<_Package> _packages = [
    _Package(
      tier: 'Package 1',
      name: 'Basic',
      duration: '1 ساعة',
      price: '2500',
      features: [
        'تصوير السيشن',
        'اللبوم 30×45',
        'تابلوه 30×40',
        'فلاشة',
      ],
      featured: false,
    ),
    _Package(
      tier: 'Package 2',
      name: 'Half Day',
      duration: '6 ساعات',
      price: '3500',
      features: [
        'تصوير السيشن',
        'تصوير القاعة',
        'اللبوم 30×45',
        'تابلوه 40×50',
        'فلاشة',
      ],
      featured: true,
    ),
    _Package(
      tier: 'Package 3',
      name: 'Full Day',
      duration: '12 ساعة',
      price: '4000',
      features: [
        'تصوير السيشن + التجهيزات',
        'تصوير القاعة',
        'اللبوم 30×45',
        'تابلوه 70×50',
        'فلاشة',
      ],
      featured: false,
    ),
  ];
}

// ─── Package Hero ─────────────────────────────────────────────
class _PackagesHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 340,
      color: AppTheme.surface,
      child: Stack(
        children: [
          // decorative gold lines
          Positioned(
            left: -40,
            top: -40,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.gold.withOpacity(0.06), width: 80),
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
                border: Border.all(color: AppTheme.gold.withOpacity(0.04), width: 100),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 90),
                const SectionLabel(text: 'Pricing'),
                const SizedBox(height: 20),
                Text(
                  'Packages & Pricing',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 62,
                    fontWeight: FontWeight.w300,
                    color: AppTheme.textPrimary,
                  ),
                ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2, end: 0),
                Text(
                  'Price List — Wedding Photography',
                  style: GoogleFonts.montserrat(
                    fontSize: 11,
                    letterSpacing: 0.25,
                    color: AppTheme.textMuted,
                  ),
                ).animate().fadeIn(delay: 300.ms, duration: 600.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Package Card ─────────────────────────────────────────────
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
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, (_hover && !featured) ? -8 : 0, 0),
        decoration: BoxDecoration(
          color: featured ? AppTheme.surface2 : AppTheme.surface,
          border: Border(
            top: BorderSide(
              color: featured || _hover ? AppTheme.gold : Colors.transparent,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badge
            if (featured)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                color: AppTheme.gold,
                child: Text(
                  'MOST POPULAR',
                  style: GoogleFonts.montserrat(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                    color: AppTheme.bg,
                  ),
                ),
              ),
            if (featured) const SizedBox(height: 20),

            // Tier
            Text(
              widget.package.tier.toUpperCase(),
              style: GoogleFonts.montserrat(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
                color: AppTheme.gold,
              ),
            ),
            const SizedBox(height: 8),

            // Name
            Text(
              widget.package.name,
              style: GoogleFonts.cormorantGaramond(
                fontSize: 36,
                fontWeight: FontWeight.w300,
                color: AppTheme.textPrimary,
                height: 1.2,
              ),
            ),

            // Duration
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 1,
                    color: AppTheme.gold.withOpacity(0.5),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.package.duration,
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: AppTheme.textMuted,
                      letterSpacing: 0.15,
                    ),
                  ),
                ],
              ),
            ),

            // Price
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    'Egyptian Pounds',
                    style: GoogleFonts.montserrat(
                      fontSize: 10,
                      color: AppTheme.textDim,
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),
            ),

            // Divider
            Container(height: 1, color: AppTheme.border),
            const SizedBox(height: 28),

            // Features
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
                          f,
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

            const Spacer(),
            const SizedBox(height: 20),

            // CTA
            Builder(
              builder: (ctx) => GoldButton(
                label: 'Book This Package',
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

// ─── Extras Section ───────────────────────────────────────────
class _ExtrasSection extends StatelessWidget {
  final List<Map<String, String>> extras = const [
    {'name': 'تصوير السيشن فقط', 'duration': 'ساعة', 'price': '1500'},
    {'name': 'تصوير القاعة فقط', 'duration': 'ساعتين', 'price': '1000'},
    {'name': 'تصوير برومو فيديو (سيشن + تجهيزات)', 'duration': '', 'price': '2000'},
    {'name': 'تصوير برومو فيديو (سيشن + قاعة)', 'duration': 'Half Day', 'price': '2500'},
    {'name': 'تصوير برومو فيديو (سيشن + تجهيزات + قاعة)', 'duration': 'Full Day', 'price': '3000'},
    {'name': 'تصوير ريل (السيشن + التجهيزات)', 'duration': '', 'price': '1000'},
    {'name': 'تصوير ريل', 'duration': 'Full Day', 'price': '1500'},
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border.all(color: AppTheme.border),
      ),
      padding: const EdgeInsets.all(48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Extra ',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 36,
                    fontWeight: FontWeight.w300,
                    color: AppTheme.textPrimary,
                  ),
                ),
                TextSpan(
                  text: 'Services',
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
            'خدمات إضافية يمكن إضافتها لأي باكدج',
            style: GoogleFonts.montserrat(
              fontSize: 12,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 32),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 1 : 2,
              crossAxisSpacing: 3,
              mainAxisSpacing: 3,
              childAspectRatio: isMobile ? 5 : 4,
            ),
            itemCount: extras.length,
            itemBuilder: (ctx, i) => _ExtraItem(data: extras[i]),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms, duration: 700.ms);
  }
}

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
          border: Border(
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
                    widget.data['name'] ?? '',
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      color: AppTheme.textMuted,
                    ),
                  ),
                  if ((widget.data['duration'] ?? '').isNotEmpty)
                    Text(
                      widget.data['duration']!,
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

// ─── Notes Section ────────────────────────────────────────────
class _NotesSection extends StatelessWidget {
  final List<String> notes = const [
    'تسليم الصور في خلال 15 لي 20 يوماً',
    'في حالة الالغاء لا يتم استرداد العربون',
    'يجب الالتزام بمواعيد السيشن المتفق عليها',
    'اسعار الباكتجات غير شاملة لرسوم المكان (الاوكيشن)',
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
      decoration: BoxDecoration(
        color: AppTheme.goldDim,
        border: const Border(
          left: BorderSide(color: AppTheme.gold, width: 3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'IMPORTANT NOTES',
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

// ─── Data Class ───────────────────────────────────────────────
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
