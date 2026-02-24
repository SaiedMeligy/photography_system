import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/section_label.dart';

class TestimonialsPreview extends StatelessWidget {
  TestimonialsPreview({super.key});

  final List<Map<String, String>> testimonials = [
    {
      'name': 'محمد و فاطمة',
      'event': 'فرح نوفمبر 2024',
      'text':
          'ابراهيم مبقاش بس مصور، ده فنان بيحس باللحظة. كل صورة حسينا فيها إحنا تاني مع بعض.',
      'initials': 'م.ف',
    },
    {
      'name': 'أحمد و نور',
      'event': 'فرح أكتوبر 2024',
      'text':
          'من أول ما دخلنا الكوشة لحد ما طلعنا، كان موجود في كل حتة. الصور جميلة جداً وبتحكي القصة كلها.',
      'initials': 'أ.ن',
    },
    {
      'name': 'كريم و ياسمين',
      'event': 'فرح سبتمبر 2024',
      'text':
          'الألبوم جه أحسن من أي حاجة تخيلتها! شكراً ابراهيم على كل لحظة حلوة اتسجلت.',
      'initials': 'ك.ي',
    },
    {
      'name': 'عمر و سارة',
      'event': 'فرح أغسطس 2024',
      'text':
          'التفاصيل الصغيرة اللي بيلتقطها ابراهيم هي الحاجة اللي بتفرقه عن غيره. موهبة حقيقية.',
      'initials': 'ع.س',
    },
    {
      'name': 'يوسف و منى',
      'event': 'فرح يوليو 2024',
      'text':
          'باكدج الفيديو كان قمة! الريل الجه نزلناه على الانستا وعمل اتفاعل رهيب.',
      'initials': 'ي.م',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Container(
      color: AppTheme.bg,
      padding: const EdgeInsets.symmetric(vertical: 100),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 80),
            child: Column(
              children: [
                const SectionLabel(text: 'Client Love'),
                const SizedBox(height: 20),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'What Our\n',
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: isMobile ? 36 : 52,
                          fontWeight: FontWeight.w300,
                          color: AppTheme.textPrimary,
                          height: 1.2,
                        ),
                      ),
                      TextSpan(
                        text: 'Couples Say',
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
            ).animate().fadeIn(duration: 700.ms),
          ),

          const SizedBox(height: 60),

          // Auto-scrolling testimonials
          SizedBox(
            height: 260,
            child: _TestimonialsCarousel(testimonials: testimonials),
          ),
        ],
      ),
    );
  }
}

class _TestimonialsCarousel extends StatefulWidget {
  final List<Map<String, String>> testimonials;
  const _TestimonialsCarousel({required this.testimonials});

  @override
  State<_TestimonialsCarousel> createState() => _TestimonialsCarouselState();
}

class _TestimonialsCarouselState extends State<_TestimonialsCarousel> {
  final ScrollController _ctrl = ScrollController();
  bool _hovering = false;
  late final _timer = _buildTimer();

  Timer _buildTimer() => Timer.periodic(
        const Duration(milliseconds: 30),
        (_) {
          if (!mounted || _hovering || !_ctrl.hasClients) return;
          final max = _ctrl.position.maxScrollExtent;
          if (_ctrl.offset >= max) {
            _ctrl.jumpTo(0);
          } else {
            _ctrl.jumpTo(_ctrl.offset + 0.8);
          }
        },
      );

  @override
  void initState() {
    super.initState();
    // Timer starts lazily on first access
    _timer; // ignore: unnecessary_statements
  }

  @override
  void dispose() {
    _timer.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final doubled = [...widget.testimonials, ...widget.testimonials];
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: ListView.separated(
        controller: _ctrl,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 40),
        itemCount: doubled.length,
        separatorBuilder: (_, __) => const SizedBox(width: 24),
        itemBuilder: (ctx, i) => _TestimonialCard(data: doubled[i]),
      ),
    );
  }
}


class _TestimonialCard extends StatefulWidget {
  final Map<String, String> data;
  const _TestimonialCard({required this.data});

  @override
  State<_TestimonialCard> createState() => _TestimonialCardState();
}

class _TestimonialCardState extends State<_TestimonialCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 360,
        padding: const EdgeInsets.all(36),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          border: Border.all(
            color: _hover ? AppTheme.gold : AppTheme.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stars
            Row(
              children: List.generate(
                5,
                (i) => const Padding(
                  padding: EdgeInsets.only(right: 3),
                  child: Icon(Icons.star, color: AppTheme.gold, size: 14),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: Text(
                '"${widget.data['text']}"',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: AppTheme.textMuted,
                  height: 1.7,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.goldDim,
                    border: Border.all(color: AppTheme.gold),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    widget.data['initials'] ?? '?',
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 16,
                      color: AppTheme.gold,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.data['name'] ?? '',
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 16,
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      widget.data['event'] ?? '',
                      style: GoogleFonts.montserrat(
                        fontSize: 10,
                        color: AppTheme.textDim,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
