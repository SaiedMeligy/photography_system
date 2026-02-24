import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/image_assets.dart';
import '../../../../core/widgets/section_label.dart';
import '../../../../core/widgets/gold_button.dart';
import '../widgets/stats_bar.dart';
import '../widgets/about_section.dart';
import '../widgets/portfolio_preview.dart';
import '../widgets/testimonials_preview.dart';
import '../widgets/contact_section.dart';
import '../widgets/footer_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentSlide = 0;
  late Timer _timer;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      _nextSlide();
    });
  }

  void _nextSlide() {
    final next = (_currentSlide + 1) % heroImages.length;
    _pageController.animateToPage(
      next,
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _HeroSection(
            pageController: _pageController,
            currentSlide: _currentSlide,
            onSlideChange: (i) => setState(() => _currentSlide = i),
            onBookTap: () => context.go('/booking'),
            onPortfolioTap: () => context.go('/portfolio'),
          ),
          const StatsBar(),
          const AboutSection(),
          PortfolioPreview(onViewAll: () => context.go('/portfolio')),
          TestimonialsPreview(),
          ContactSection(),
          const FooterSection(),
        ],
      ),
    );
  }
}

// ─── Hero Section ─────────────────────────────────────────────
class _HeroSection extends StatelessWidget {
  final PageController pageController;
  final int currentSlide;
  final void Function(int) onSlideChange;
  final VoidCallback onBookTap;
  final VoidCallback onPortfolioTap;

  const _HeroSection({
    required this.pageController,
    required this.currentSlide,
    required this.onSlideChange,
    required this.onBookTap,
    required this.onPortfolioTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return SizedBox(
      height: size.height,
      child: Stack(
        children: [
          // Slideshow
          PageView.builder(
            controller: pageController,
            onPageChanged: onSlideChange,
            itemCount: heroImages.length,
            itemBuilder: (_, i) {
              return Image.asset(
                heroImages[i],
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              );
            },
          ),

          // Overlay — adapts to light/dark theme
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0.90),
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0.50),
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
                ],
              ),
            ),
          ),

          // Bottom fade
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Theme.of(context).scaffoldBackgroundColor,
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0),
                  ],
                ),
              ),
            ),
          ),

          // Content
          Positioned(
            left: isMobile ? 24 : 80,
            right: isMobile ? 24 : size.width * 0.35,
            top: 0,
            bottom: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Eyebrow
                Row(
                  children: [
                    Container(width: 60, height: 1, color: AppTheme.gold),
                    const SizedBox(width: 14),
                    Text(
                      'WEDDING PHOTOGRAPHY',
                      style: GoogleFonts.montserrat(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.4,
                        color: AppTheme.gold,
                      ),
                    ),
                  ],
                )
                    .animate()
                    .fadeIn(delay: 300.ms, duration: 800.ms)
                    .slideY(begin: 0.3, end: 0),
                const SizedBox(height: 28),

                // Title
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Capturing\n',
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: isMobile ? 66 : 96,
                          fontWeight: FontWeight.w300,
                          color: AppTheme.textPrimary,
                          height: 1.05,
                        ),
                      ),
                      TextSpan(
                        text: 'Your Story\n',
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: isMobile ? 66 : 96,
                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.italic,
                          color: AppTheme.gold,
                          height: 1.05,
                        ),
                      ),
                      TextSpan(
                        text: 'Forever.',
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: isMobile ? 66 : 96,
                          fontWeight: FontWeight.w300,
                          color: AppTheme.textPrimary,
                          height: 1.05,
                        ),
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(delay: 500.ms, duration: 900.ms)
                    .slideY(begin: 0.3, end: 0),
                const SizedBox(height: 28),

                // Description
                Text(
                  'احنا مش بس بنصور — احنا بنحكي حكايتك.\nمن التجهيزات للرقصة الأخيرة، كل لحظة تتسجل بعين فنية.',
                  style: GoogleFonts.montserrat(
                    fontSize: 17,
                    fontWeight: FontWeight.w300,
                    color: AppTheme.textMuted,
                    height: 1.9,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 700.ms, duration: 800.ms)
                    .slideY(begin: 0.2, end: 0),
                const SizedBox(height: 48),

                // Buttons
                Wrap(
                  spacing: 16,
                  runSpacing: 12,
                  children: [
                    GoldButton(
                      label: 'Book Your Date',
                      onTap: onBookTap,
                      icon: Icons.calendar_today_outlined,
                    ),
                    GoldButton(
                      label: 'View Work',
                      onTap: onPortfolioTap,
                      outline: true,
                      icon: Icons.photo_library_outlined,
                    ),
                  ],
                )
                    .animate()
                    .fadeIn(delay: 900.ms, duration: 800.ms)
                    .slideY(begin: 0.2, end: 0),
              ],
            ),
          ),

          // Slide dots
          Positioned(
            bottom: 40,
            right: 60,
            child: Row(
              children: List.generate(heroImages.length, (i) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: i == currentSlide ? 24 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: i == currentSlide
                        ? AppTheme.gold
                        : AppTheme.textMuted.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
          ),

          // Scroll indicator
          Positioned(
            bottom: 36,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  'SCROLL',
                  style: GoogleFonts.montserrat(
                    fontSize: 8,
                    letterSpacing: 0.4,
                    color: AppTheme.textDim,
                  ),
                ),
                const SizedBox(height: 8),
                _ScrollLine(),
              ],
            )
                .animate()
                .fadeIn(delay: 1200.ms, duration: 600.ms),
          ),
        ],
      ),
    );
  }
}

class _ScrollLine extends StatefulWidget {
  @override
  State<_ScrollLine> createState() => _ScrollLineState();
}

class _ScrollLineState extends State<_ScrollLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: false);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 1,
      child: AnimatedBuilder(
        animation: _anim,
        builder: (_, __) => CustomPaint(
          painter: _LinePainter(_anim.value),
        ),
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  final double progress;
  _LinePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppTheme.gold, AppTheme.gold.withOpacity(0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawLine(
      Offset(0, size.height * (1 - progress)),
      Offset(0, size.height * progress),
      paint..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(_LinePainter old) => old.progress != progress;
}
