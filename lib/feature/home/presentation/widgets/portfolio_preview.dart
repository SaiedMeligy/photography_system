import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/section_label.dart';
import '../../../../core/widgets/gold_button.dart';
import '../../../portfolio/cubit/portfolio_cubit.dart';
import '../../../../core/translations/locale_keys.g.dart';

class PortfolioPreview extends StatelessWidget {
  final VoidCallback onViewAll;
  const PortfolioPreview({super.key, required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    context.locale; // Ensure rebuild on locale change
    return BlocProvider(
      // Only load the first 6 images for the preview
      create: (_) => PortfolioCubit(previewCount: 6),
      child: _PortfolioPreviewView(onViewAll: onViewAll),
    );
  }
}

// ─── View ──────────────────────────────────────────────────────
class _PortfolioPreviewView extends StatelessWidget {
  final VoidCallback onViewAll;
  const _PortfolioPreviewView({required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    context.locale;
    final isMobile = MediaQuery.of(context).size.width < 700;

    return BlocBuilder<PortfolioCubit, PortfolioState>(
      builder: (context, state) {
        return Stack(
          children: [
            Container(
              color: AppTheme.bgAlt,
              padding: EdgeInsets.symmetric(
                vertical: 100,
                horizontal: isMobile ? 24 : 80,
              ),
              child: Column(
                children: [
                  // ── Header
                  Column(
                    children: [
                      SectionLabel(text: LocaleKeys.section_portfolio.tr()),
                      const SizedBox(height: 20),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${LocaleKeys.portfolio_title_1.tr()}\n',
                              style: GoogleFonts.cormorantGaramond(
                                fontSize: isMobile ? 36 : 52,
                                fontWeight: FontWeight.w300,
                                color: AppTheme.textPrimary,
                                height: 1.2,
                              ),
                            ),
                            TextSpan(
                              text: LocaleKeys.portfolio_title_2.tr(),
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
                        LocaleKeys.portfolio_subtitle.tr(),
                        style: GoogleFonts.montserrat(
                          fontSize: 13,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 700.ms),

                  const SizedBox(height: 60),

                  // ── Grid
                  state.isLoaded
                      ? _PreviewGrid(images: state.images)
                      : const _LoadingPlaceholder(),

                  const SizedBox(height: 50),

                  GoldButton(
                    label: LocaleKeys.portfolio_btn.tr(),
                    onTap: onViewAll,
                    outline: true,
                    icon: Icons.arrow_forward,
                  ),
                ],
              ),
            ),

            // ── Lightbox
            if (state.isLightboxOpen)
              RepaintBoundary(
                child: _PreviewLightbox(
                  images: state.images,
                  index: state.lightboxIndex,
                  onClose: () =>
                      context.read<PortfolioCubit>().closeLightbox(),
                  onPrev: () => context.read<PortfolioCubit>().prevImage(),
                  onNext: () => context.read<PortfolioCubit>().nextImage(),
                ),
              ),
          ],
        );
      },
    );
  }
}

// ─── Loading Placeholder ───────────────────────────────────────
class _LoadingPlaceholder extends StatelessWidget {
  const _LoadingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 300,
      child: Center(
        child: CircularProgressIndicator(
          color: AppTheme.gold,
          strokeWidth: 1,
        ),
      ),
    );
  }
}

// ─── Grid ──────────────────────────────────────────────────────
class _PreviewGrid extends StatelessWidget {
  final List<String> images;
  const _PreviewGrid({required this.images});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 2 : 3,
        crossAxisSpacing: 3,
        mainAxisSpacing: 3,
        childAspectRatio: isMobile ? 0.8 : 0.75,
      ),
      itemCount: images.length,
      itemBuilder: (ctx, i) => RepaintBoundary(
        child: _PreviewItem(
          imagePath: images[i],
          index: i,
          isMobile: isMobile,
          onTap: () => ctx.read<PortfolioCubit>().openLightbox(i),
        ),
      ),
    );
  }
}

// ─── Grid Item ─────────────────────────────────────────────────
class _PreviewItem extends StatefulWidget {
  final String imagePath;
  final int index;
  final bool isMobile;
  final VoidCallback onTap;

  const _PreviewItem({
    required this.imagePath,
    required this.index,
    required this.isMobile,
    required this.onTap,
  });

  @override
  State<_PreviewItem> createState() => _PreviewItemState();
}

class _PreviewItemState extends State<_PreviewItem> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
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
                  cacheWidth: widget.isMobile ? 350 : 600,
                ),
              ),
              AnimatedOpacity(
                opacity: _hover ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 400),
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
            delay: Duration(milliseconds: widget.index * 80),
            duration: 700.ms,
          )
          .slideY(begin: 0.1, end: 0),
    );
  }
}

// ─── Lightbox ──────────────────────────────────────────────────
class _PreviewLightbox extends StatefulWidget {
  final List<String> images;
  final int index;
  final VoidCallback onClose;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const _PreviewLightbox({
    required this.images,
    required this.index,
    required this.onClose,
    required this.onPrev,
    required this.onNext,
  });

  @override
  State<_PreviewLightbox> createState() => _PreviewLightboxState();
}

class _PreviewLightboxState extends State<_PreviewLightbox> {
  late final PageController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = PageController(initialPage: widget.index);
  }

  @override
  void didUpdateWidget(_PreviewLightbox old) {
    super.didUpdateWidget(old);
    if (old.index != widget.index && _ctrl.hasClients) {
      _ctrl.animateToPage(
        widget.index,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRtl = context.locale.languageCode == 'ar';

    return Positioned.fill(
      child: GestureDetector(
        onTap: widget.onClose,
        child: ColoredBox(
          color: Colors.black.withOpacity(0.96),
          child: Stack(
            children: [
              // ── Gallery
              PhotoViewGallery.builder(
                itemCount: widget.images.length,
                pageController: _ctrl,
                onPageChanged: (i) {
                  if (i > widget.index) {
                    widget.onNext();
                  } else if (i < widget.index) {
                    widget.onPrev();
                  }
                },
                builder: (ctx, i) => PhotoViewGalleryPageOptions(
                  imageProvider:
                      ResizeImage(AssetImage(widget.images[i]), width: 1200),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2,
                ),
                backgroundDecoration:
                    const BoxDecoration(color: Colors.transparent),
              ),

              // ── Close (always top-end)
              PositionedDirectional(
                top: 30,
                end: 30,
                child: GestureDetector(
                  onTap: widget.onClose,
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

              // ── Prev (start side)
              PositionedDirectional(
                start: 20,
                top: 0,
                bottom: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: widget.onPrev,
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppTheme.surface.withOpacity(0.7),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Icon(
                        isRtl ? Icons.chevron_right : Icons.chevron_left,
                        color: AppTheme.textPrimary,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),

              // ── Next (end side)
              PositionedDirectional(
                end: 20,
                top: 0,
                bottom: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: widget.onNext,
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppTheme.surface.withOpacity(0.7),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Icon(
                        isRtl ? Icons.chevron_left : Icons.chevron_right,
                        color: AppTheme.textPrimary,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),

              // ── Counter
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    '${widget.index + 1} / ${widget.images.length}',
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
      ),
    );
  }
}


