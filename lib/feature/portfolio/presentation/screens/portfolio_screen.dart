import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/section_label.dart';
import '../../cubit/portfolio_cubit.dart';
import '../../../home/presentation/widgets/footer_section.dart';
import '../../../../core/translations/locale_keys.g.dart';

// Number of columns in the portfolio grid
const _kColumns = 3;
const _kMobileColumns = 1;

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to locale
    context.locale;
    return BlocProvider(
      create: (_) => PortfolioCubit(),
      child: const _PortfolioView(),
    );
  }
}

// ─── Main View ────────────────────────────────────────────────
class _PortfolioView extends StatelessWidget {
  const _PortfolioView();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;
    final isRtl = context.locale.languageCode == 'ar';

    return BlocBuilder<PortfolioCubit, PortfolioState>(
      builder: (context, state) {
        return Stack(
          children: [
            // ── Main scroll content
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _PortfolioHero()),
                SliverToBoxAdapter(
                  child: Container(
                    color: AppTheme.bgAlt,
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 12 : 60,
                      vertical: 40,
                    ),
                    child: Column(
                      children: [
                        SectionLabel(text: LocaleKeys.portfolio_story_label.tr()),
                        const SizedBox(height: 16),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                               TextSpan(
                                 text: '${LocaleKeys.portfolio_story_title_1.tr()}\n',
                                 style: GoogleFonts.cormorantGaramond(
                                   fontSize: isMobile ? 36 : 52,
                                   fontWeight: FontWeight.w300,
                                   color: AppTheme.textPrimary,
                                   height: 1.2,
                                 ),
                               ),
                               TextSpan(
                                 text: LocaleKeys.portfolio_story_title_2.tr(),
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
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 12 : 60,
                    vertical: 20,
                  ),
                  sliver: state.isLoaded
                      ? _PortfolioSliverGrid(images: state.images)
                      : const SliverToBoxAdapter(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(80),
                              child: CircularProgressIndicator(
                                color: AppTheme.gold,
                                strokeWidth: 1,
                              ),
                            ),
                          ),
                        ),
                ),
                const SliverToBoxAdapter(child: FooterSection()),
              ],
            ),

            // ── Lightbox (only paints when open)
            if (state.isLightboxOpen)
              RepaintBoundary(
                child: _Lightbox(
                  images: state.images,
                  index: state.lightboxIndex,
                  onClose: () => context.read<PortfolioCubit>().closeLightbox(),
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

// ─── Hero ─────────────────────────────────────────────────────
class _PortfolioHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PortfolioCubit, PortfolioState>(
      builder: (context, state) {
        if (!state.isLoaded) return const SizedBox(height: 380);
        return SizedBox(
          height: 380,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                state.images[3],
                fit: BoxFit.cover,
                cacheWidth: MediaQuery.of(context).size.width < 700 ? 800 : 1920,
              ),
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
                    SectionLabel(text: LocaleKeys.portfolio_page_label.tr()),
                    const SizedBox(height: 20),
                    Text(
                      LocaleKeys.portfolio_page_title.tr(),
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
      },
    );
  }
}

// ─── Grid (SliverList of rows = same lazy behaviour as ListView.builder) ────
class _PortfolioSliverGrid extends StatelessWidget {
  final List<String> images;
  const _PortfolioSliverGrid({required this.images});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;
    final cols = isMobile ? _kMobileColumns : _kColumns;
    final rowCount = (images.length / cols).ceil();

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        // These two flags let Flutter dispose off-screen items from memory
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: false, // managed manually below
        childCount: rowCount,
        (ctx, row) {
          final startIdx = row * cols;
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(cols, (col) {
                final i = startIdx + col;
                if (i >= images.length) {
                  return const Expanded(child: SizedBox());
                }
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: col == 0 ? 0 : 4),
                    child: RepaintBoundary(
                      child: _GridItem(
                        key: ValueKey(images[i]),
                        imagePath: images[i],
                        isMobile: isMobile,
                        onTap: () =>
                            ctx.read<PortfolioCubit>().openLightbox(i),
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        },
      ),
    );
  }
}

// ─── Grid Item ────────────────────────────────────────────────
// NOTE: No flutter_animate here — animations during scroll cause jank.
// Hover effects are enough for a premium feel without hurting performance.
class _GridItem extends StatefulWidget {
  final String imagePath;
  final bool isMobile;
  final VoidCallback onTap;

  const _GridItem({
    super.key,
    required this.imagePath,
    required this.isMobile,
    required this.onTap,
  });

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
        child: SizedBox(
          height: widget.isMobile ? 300 : 370,
          child: ClipRect(
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Image: lower cacheWidth on mobile = much less GPU memory
                AnimatedScale(
                  scale: _hover ? 1.06 : 1.0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                  child: Image.asset(
                    widget.imagePath,
                    fit: BoxFit.cover,
                    cacheWidth: widget.isMobile ? 360 : 680,
                  ),
                ),
                // Hover overlay — desktop only (mobile has no hover)
                AnimatedOpacity(
                  opacity: _hover ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: const ColoredBox(
                    color: Colors.black54,
                    child: Center(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.gold,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Icon(Icons.zoom_in,
                              color: AppTheme.bg, size: 26),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Lightbox ─────────────────────────────────────────────────
// StatefulWidget so the PageController persists across state rebuilds.
// Without this, every prev/next tap recreates the controller at initialPage
// and the gallery never actually moves.
class _Lightbox extends StatefulWidget {
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
  State<_Lightbox> createState() => _LightboxState();
}

class _LightboxState extends State<_Lightbox> {
  late final PageController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = PageController(initialPage: widget.index);
  }

  @override
  void didUpdateWidget(_Lightbox old) {
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
    // تحديد اتجاه اللغة الحالية
    final isRtl = EasyLocalization.of(context)?.locale.languageCode == 'ar';

    return GestureDetector(
      onTap: widget.onClose,
      child: ColoredBox(
        color: Colors.black.withOpacity(0.96),
        child: Stack(
          children: [
            // ── 1. معرض الصور
            PhotoViewGallery.builder(
              itemCount: widget.images.length,
              pageController: _ctrl,
              onPageChanged: (i) {
                // مزامنة الكيوبيت عند السحب باليد
                if (i > widget.index) {
                  widget.onNext();
                } else if (i < widget.index) {
                  widget.onPrev();
                }
              },
              builder: (ctx, i) => PhotoViewGalleryPageOptions(
                imageProvider: ResizeImage(AssetImage(widget.images[i]), width: 1600),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
              ),
              backgroundDecoration: const BoxDecoration(color: Colors.transparent),
            ),

            // ── 2. زر الإغلاق (Close Icon)
            // نضعه في الزاوية العلوية (يمين في الإنجليزي، يسار في العربي)
            Positioned(
              top: 140,
              right: isRtl ? null : 20,
              left: isRtl ? 20 : null,
              child: GestureDetector(
                onTap: widget.onClose,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24),
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 28),
                ),
              ),
            ),

            // ── 3. سهم السابق (Prev)
            Positioned(
              left: isRtl ? null : 20,
              right: isRtl ? 20 : null,
              top: 0,
              bottom: 0,
              child: Center(
                child: GestureDetector(
                  onTap: widget.onPrev,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.surface.withOpacity(0.7),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Icon(
                      isRtl ? Icons.chevron_right : Icons.chevron_left,
                      color: AppTheme.textPrimary,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),

            // ── 4. سهم التالي (Next)
            Positioned(
              right: isRtl ? null : 20,
              left: isRtl ? 20 : null,
              top: 0,
              bottom: 0,
              child: Center(
                child: GestureDetector(
                  onTap: widget.onNext,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.surface.withOpacity(0.7),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Icon(
                      isRtl ? Icons.chevron_left : Icons.chevron_right,
                      color: AppTheme.textPrimary,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),

            // ── 5. العداد (Counter)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${widget.index + 1} / ${widget.images.length}',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
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
