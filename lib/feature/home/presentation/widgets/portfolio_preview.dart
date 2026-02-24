import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/section_label.dart';
import '../../../../core/widgets/gold_button.dart';
import '../../../../core/constants/image_assets.dart';

class PortfolioPreview extends StatelessWidget {
  final VoidCallback onViewAll;
  const PortfolioPreview({super.key, required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;
    // Show first 6 images as preview
    final previewImages = portfolioImages.take(6).toList();

    return Container(
      color: AppTheme.bgAlt,
      padding: EdgeInsets.symmetric(
        vertical: 100,
        horizontal: isMobile ? 24 : 80,
      ),
      child: Column(
        children: [
          // Header
          Column(
            children: [
              const SectionLabel(text: 'Portfolio'),
              const SizedBox(height: 20),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Stories We\'ve\n',
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: isMobile ? 36 : 52,
                        fontWeight: FontWeight.w300,
                        color: AppTheme.textPrimary,
                        height: 1.2,
                      ),
                    ),
                    TextSpan(
                      text: 'Told Through Images',
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
                'ألبوم فيلا — قصة كاملة من الأول للآخر',
                style: GoogleFonts.montserrat(
                  fontSize: 13,
                  color: AppTheme.textMuted,
                ),
              ),
            ],
          ).animate().fadeIn(duration: 700.ms),

          const SizedBox(height: 60),

          // Grid
          _PortfolioGrid(images: previewImages),

          const SizedBox(height: 50),

          GoldButton(
            label: 'View Full Portfolio',
            onTap: onViewAll,
            outline: true,
            icon: Icons.arrow_forward,
          ),
        ],
      ),
    );
  }
}

class _PortfolioGrid extends StatelessWidget {
  final List<String> images;
  const _PortfolioGrid({required this.images});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    if (isMobile) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 3,
          mainAxisSpacing: 3,
          childAspectRatio: 0.8,
        ),
        itemCount: images.length,
        itemBuilder: (ctx, i) => _PortfolioItem(
          imagePath: images[i],
          delay: i * 80,
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 3,
        mainAxisSpacing: 3,
        childAspectRatio: 0.75,
      ),
      itemCount: images.length,
      itemBuilder: (ctx, i) => _PortfolioItem(
        imagePath: images[i],
        delay: i * 100,
      ),
    );
  }
}

class _PortfolioItem extends StatefulWidget {
  final String imagePath;
  final int delay;
  const _PortfolioItem({required this.imagePath, this.delay = 0});

  @override
  State<_PortfolioItem> createState() => _PortfolioItemState();
}

class _PortfolioItemState extends State<_PortfolioItem> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        height: 300,
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedScale(
              scale: _hover ? 1.07 : 1.0,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOut,
              child: Image.asset(
                widget.imagePath,
                fit: BoxFit.cover,
              ),
            ),
            AnimatedOpacity(
              opacity: _hover ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 400),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      AppTheme.bg.withOpacity(0.85),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ألبوم فيلا',
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 22,
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Text(
                          'WEDDING STORY',
                          style: GoogleFonts.montserrat(
                            fontSize: 9,
                            letterSpacing: 0.2,
                            color: AppTheme.gold,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(delay: Duration(milliseconds: widget.delay), duration: 700.ms)
          .slideY(begin: 0.1, end: 0),
    );
  }
}
