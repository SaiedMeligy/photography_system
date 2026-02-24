import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/section_label.dart';
import '../../../../core/constants/image_assets.dart';
import '../../../home/presentation/widgets/footer_section.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  int _lightboxIndex = -1;

  void _openLightbox(int index) => setState(() => _lightboxIndex = index);
  void _closeLightbox() => setState(() => _lightboxIndex = -1);
  void _prevImage() {
    if (_lightboxIndex > 0) setState(() => _lightboxIndex--);
  }
  void _nextImage() {
    if (_lightboxIndex < portfolioImages.length - 1) setState(() => _lightboxIndex++);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              // Hero banner
              _PortfolioHero(),

              // Grid
              Container(
                color: AppTheme.bgAlt,
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 12 : 60,
                  vertical: 80,
                ),
                child: Column(
                  children: [
                    const SectionLabel(text: 'Album Villa'),
                    const SizedBox(height: 16),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'A Wedding\n',
                            style: GoogleFonts.cormorantGaramond(
                              fontSize: isMobile ? 36 : 52,
                              fontWeight: FontWeight.w300,
                              color: AppTheme.textPrimary,
                              height: 1.2,
                            ),
                          ),
                          TextSpan(
                            text: 'Story in Full',
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
                    const SizedBox(height: 50),
                    _PortfolioMasonryGrid(
                      images: portfolioImages,
                      onTap: _openLightbox,
                    ),
                  ],
                ),
              ),

              const FooterSection(),
            ],
          ),
        ),

        // Lightbox
        if (_lightboxIndex >= 0)
          _Lightbox(
            images: portfolioImages,
            index: _lightboxIndex,
            onClose: _closeLightbox,
            onPrev: _prevImage,
            onNext: _nextImage,
          ),
      ],
    );
  }
}

// ─── Portfolio Hero ────────────────────────────────────────────
class _PortfolioHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 380,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(portfolioImages[3], fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.bg.withOpacity(0.85),
                  AppTheme.bg.withOpacity(0.45),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 90),
                const SectionLabel(text: 'Our Work'),
                const SizedBox(height: 20),
                Text(
                  'Portfolio',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 72,
                    fontWeight: FontWeight.w300,
                    color: AppTheme.textPrimary,
                  ),
                ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2, end: 0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Masonry Grid ─────────────────────────────────────────────
class _PortfolioMasonryGrid extends StatelessWidget {
  final List<String> images;
  final void Function(int) onTap;
  const _PortfolioMasonryGrid({required this.images, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;
    final cols = isMobile ? 1 : 3;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        childAspectRatio: 0.75,
      ),
      itemCount: images.length,
      itemBuilder: (ctx, i) => _GridItem(
        imagePath: images[i],
        index: i,
        onTap: () => onTap(i),
      ),
    );
  }
}

class _GridItem extends StatefulWidget {
  final String imagePath;
  final int index;
  final VoidCallback onTap;
  const _GridItem({required this.imagePath, required this.index, required this.onTap});

  @override
  State<_GridItem> createState() => _GridItemState();
}

class _GridItemState extends State<_GridItem> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: ClipRect(
          child: Stack(
            fit: StackFit.expand,
            children: [
              AnimatedScale(
                scale: _hover ? 1.06 : 1.0,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut,
                child: Image.asset(widget.imagePath, fit: BoxFit.cover),
              ),
              AnimatedOpacity(
                opacity: _hover ? 1 : 0,
                duration: const Duration(milliseconds: 350),
                child: Container(
                  color: AppTheme.bg.withOpacity(0.55),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.gold.withOpacity(0.9),
                      ),
                      child: const Icon(
                        Icons.zoom_in,
                        color: AppTheme.bg,
                        size: 26,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
          .animate()
          .fadeIn(
            delay: Duration(milliseconds: (widget.index % 9) * 60),
            duration: 600.ms,
          )
          .slideY(begin: 0.08, end: 0),
    );
  }
}

// ─── Lightbox ─────────────────────────────────────────────────
class _Lightbox extends StatelessWidget {
  final List<String> images;
  final int index;
  final VoidCallback onClose;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const _Lightbox({
    required this.images,
    required this.index,
    required this.onClose,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose,
      child: Container(
        color: Colors.black.withOpacity(0.96),
        child: Stack(
          children: [
            // Image viewer
            PhotoViewGallery.builder(
              itemCount: images.length,
              pageController: PageController(initialPage: index),
              builder: (ctx, i) => PhotoViewGalleryPageOptions(
                imageProvider: AssetImage(images[i]),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
              ),
              backgroundDecoration: const BoxDecoration(color: Colors.transparent),
            ),

            // Close
            Positioned(
              top: 30,
              right: 30,
              child: GestureDetector(
                onTap: onClose,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.surface.withOpacity(0.8),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: const Icon(Icons.close, color: AppTheme.textPrimary),
                ),
              ),
            ),

            // Prev
            Positioned(
              left: 20,
              top: 0,
              bottom: 0,
              child: Center(
                child: GestureDetector(
                  onTap: onPrev,
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppTheme.surface.withOpacity(0.7),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: const Icon(Icons.chevron_left, color: AppTheme.textPrimary, size: 32),
                  ),
                ),
              ),
            ),

            // Next
            Positioned(
              right: 20,
              top: 0,
              bottom: 0,
              child: Center(
                child: GestureDetector(
                  onTap: onNext,
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppTheme.surface.withOpacity(0.7),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: const Icon(Icons.chevron_right, color: AppTheme.textPrimary, size: 32),
                  ),
                ),
              ),
            ),

            // Counter
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  '${index + 1} / ${images.length}',
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: AppTheme.textMuted,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
