import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/section_label.dart';
import '../../../../core/widgets/gold_button.dart';
import '../../../../core/translations/locale_keys.g.dart';

class TestimonialsPreview extends StatefulWidget {
  const TestimonialsPreview({super.key});

  @override
  State<TestimonialsPreview> createState() => _TestimonialsPreviewState();
}

class _TestimonialsPreviewState extends State<TestimonialsPreview> {
  final List<Map<String, String>> _addedTestimonials = [];

  void _showAddReview() {
    showDialog(
      context: context,
      builder: (ctx) => _AddReviewDialog(
        onAdd: (review) {
          setState(() {
            _addedTestimonials.insert(0, review);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.locale; // Listen for locale changes
    final isMobile = MediaQuery.of(context).size.width < 700;

    final List<Map<String, String>> defaultTestimonials = [
      {
        'name': 'محمد وفاطمة',
        'event': 'فرح نوفمبر 2024',
        'text': 'ابراهيم مبقاش بس مصور، ده فنان بيحس باللحظة. كل صورة حسينا فيها إحنا تاني مع بعض.',
        'initials': 'م.ف',
      },
      {
        'name': 'أحمد ونور',
        'event': 'فرح أكتوبر 2024',
        'text': 'من أول ما دخلنا الكوشة لحد ما طلعنا، كان موجود في كل حتة. الصور جميلة جداً وبتحكي القصة كلها.',
        'initials': 'أ.ن',
      },
      {
        'name': 'كريم وياسمين',
        'event': 'فرح سبتمبر 2024',
        'text': 'الألبوم جه أحسن من أي حاجة تخيلتها! شكراً ابراهيم على كل لحظة حلوة اتسجلت.',
        'initials': 'ك.ي',
      },
      {
        'name': 'عمر وسارة',
        'event': 'فرح أغسطس 2024',
        'text': 'التفاصيل الصغيرة اللي بيلتقطها ابراهيم هي الحاجة اللي بتفرقه عن غيره. موهبة حقيقية.',
        'initials': 'ع.س',
      },
      {
        'name': 'يوسف ومنى',
        'event': 'فرح يوليو 2024',
        'text': 'باكدج الفيديو كان قمة! الريل الجه نزلناه على الانستا وعمل اتفاعل رهيب.',
        'initials': 'ي.م',
      },
    ];

    final testimonialsList = [..._addedTestimonials, ...defaultTestimonials];

    return Container(
      color: AppTheme.bg,
      padding: const EdgeInsets.symmetric(vertical: 100),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 80),
            child: Column(
              children: [
                SectionLabel(text: LocaleKeys.section_testimonials.tr()),
                const SizedBox(height: 20),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${LocaleKeys.testimonials_title_1.tr()}\n',
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: isMobile ? 36 : 52,
                          fontWeight: FontWeight.w300,
                          color: AppTheme.textPrimary,
                          height: 1.2,
                        ),
                      ),
                      TextSpan(
                        text: LocaleKeys.testimonials_title_2.tr(),
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

          SizedBox(
            height: 260,
            child: _TestimonialsCarousel(testimonials: testimonialsList),
          ),

          const SizedBox(height: 50),

          GoldButton(
            label: LocaleKeys.testimonials_form_btn.tr(),
            onTap: _showAddReview,
            outline: true,
            icon: Icons.rate_review_outlined,
          ).animate().fadeIn(delay: 400.ms, duration: 700.ms),
        ],
      ),
    );
  }
}

class _AddReviewDialog extends StatefulWidget {
  final Function(Map<String, String>) onAdd;
  const _AddReviewDialog({required this.onAdd});

  @override
  State<_AddReviewDialog> createState() => _AddReviewDialogState();
}

class _AddReviewDialogState extends State<_AddReviewDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _eventCtrl = TextEditingController();
  final _textCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: AppTheme.border),
        borderRadius: BorderRadius.zero,
      ),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(40),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.testimonial_form_title.tr(),
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 32,
                  fontWeight: FontWeight.w300,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                LocaleKeys.testimonial_form_subtitle.tr(),
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  color: AppTheme.textMuted,
                ),
              ),
              const SizedBox(height: 32),
              _buildField(LocaleKeys.testimonial_form_name.tr(), _nameCtrl),
              const SizedBox(height: 20),
              _buildField(LocaleKeys.testimonial_form_event.tr(), _eventCtrl),
              const SizedBox(height: 20),
              _buildField(LocaleKeys.testimonial_form_text.tr(), _textCtrl, maxLines: 4),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'CANCEL',
                      style: GoogleFonts.montserrat(
                        fontSize: 11,
                        letterSpacing: 1,
                        color: AppTheme.textDim,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  GoldButton(
                    label: LocaleKeys.testimonial_form_submit.tr(),
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        final initials = _nameCtrl.text.trim().split(' ')
                            .take(2).map((e) => e.isNotEmpty ? e[0] : '').join('.');

                        widget.onAdd({
                          'name': _nameCtrl.text.trim(),
                          'event': _eventCtrl.text.trim(),
                          'text': _textCtrl.text.trim(),
                          'initials': initials.toUpperCase(),
                        });

                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppTheme.surface,
                            content: Text(
                              LocaleKeys.testimonial_success.tr(),
                              style: GoogleFonts.montserrat(color: AppTheme.gold),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.montserrat(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
            color: AppTheme.textDim,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: ctrl,
          maxLines: maxLines,
          style: GoogleFonts.montserrat(fontSize: 13, color: AppTheme.textPrimary),
          validator: (v) => (v == null || v.trim().isEmpty) ? LocaleKeys.form_required.tr() : null,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
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
    _timer; 
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
        key: ValueKey(widget.testimonials.length), 
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
