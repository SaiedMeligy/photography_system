import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/section_label.dart';
import '../../../../core/widgets/gold_button.dart';
import '../../cubit/testimonials_cubit.dart';
import '../../../home/presentation/widgets/footer_section.dart';

class TestimonialsScreen extends StatelessWidget {
  const TestimonialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale;
    return BlocProvider(
      create: (_) => TestimonialsCubit(),
      child: const _TestimonialsView(),
    );
  }
}

// ─── Main View ────────────────────────────────────────────────
class _TestimonialsView extends StatelessWidget {
  const _TestimonialsView();

  void _showAddReview(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => BlocProvider.value(
        value: context.read<TestimonialsCubit>(),
        child: const _AddReviewDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;
    final isRtl = context.locale.languageCode == 'ar';

    return BlocBuilder<TestimonialsCubit, TestimonialsState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              // ── Hero
              Container(
                height: 340,
                color: AppTheme.surface,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 90),
                      SectionLabel(text: 'testimonials_page_label'.tr()),
                      const SizedBox(height: 20),
                      Text(
                        'testimonials_page_title'.tr(),
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 62,
                          fontWeight: FontWeight.w300,
                          color: AppTheme.textPrimary,
                        ),
                      ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2, end: 0),
                      Text(
                        'testimonials_page_subtitle'.tr(),
                        style: GoogleFonts.montserrat(
                          fontSize: 13,
                          color: AppTheme.textMuted,
                        ),
                      ).animate().fadeIn(delay: 300.ms),
                    ],
                  ),
                ),
              ),

              // ── Body
              Container(
                color: AppTheme.bg,
                padding: EdgeInsets.symmetric(
                  vertical: 60,
                  horizontal: isMobile ? 24 : 80,
                ),
                child: Column(
                  children: [
                    const _RatingSummary(),
                    const SizedBox(height: 80),
                    SectionLabel(text: 'section_happy_couples'.tr()),
                    const SizedBox(height: 16),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${'testimonials_title_1'.tr()}\n',
                            style: GoogleFonts.cormorantGaramond(
                              fontSize: isMobile ? 36 : 52,
                              fontWeight: FontWeight.w300,
                              color: AppTheme.textPrimary,
                              height: 1.2,
                            ),
                          ),
                          TextSpan(
                            text: 'testimonials_title_2'.tr(),
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
                    const SizedBox(height: 40),
                    GoldButton(
                      label: 'testimonials_form_btn'.tr(),
                      onTap: () => _showAddReview(context),
                      icon: Icons.rate_review,
                    ),
                    const SizedBox(height: 60),

                    // ── Cards grid/list
                    isMobile
                        ? Column(
                            children: state.testimonials.asMap().entries.map((e) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 24),
                                child: RepaintBoundary(
                                  child: _TestimonialCard(
                                    testimonial: e.value,
                                    delay: e.key * 100,
                                  ),
                                ),
                              );
                            }).toList(),
                          )
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 30,
                              mainAxisSpacing: 30,
                              childAspectRatio: 1.4,
                            ),
                            itemCount: state.testimonials.length,
                            itemBuilder: (ctx, i) => RepaintBoundary(
                              child: _TestimonialCard(
                                testimonial: state.testimonials[i],
                                delay: i * 100,
                              ),
                            ),
                          ),
                  ],
                ),
              ),

              const FooterSection(),
            ],
          ),
        );
      },
    );
  }
}

// ─── Rating Summary ───────────────────────────────────────────
class _RatingSummary extends StatelessWidget {
  const _RatingSummary();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Container(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 40 : 50, horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: _RatingStatItem(
              value: '5.0',
              label: 'stat_avg_rating'.tr(),
              isMobile: isMobile,
            ),
          ),
          Container(width: 1, height: isMobile ? 60 : 100, color: AppTheme.border),
          Expanded(
            child: _RatingStatItem(
              value: '200+',
              label: 'stat_happy'.tr(),
              isMobile: isMobile,
            ),
          ),
          Container(width: 1, height: isMobile ? 60 : 100, color: AppTheme.border),
          Expanded(
            child: _RatingStatItem(
              value: '98%',
              label: 'stat_recommend'.tr(),
              isMobile: isMobile,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms);
  }
}

class _RatingStatItem extends StatelessWidget {
  final String value;
  final String label;
  final bool isMobile;

  const _RatingStatItem({
    required this.value,
    required this.label,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: GoogleFonts.cormorantGaramond(
            fontSize: isMobile ? 42 : 72,
            fontWeight: FontWeight.w300,
            color: AppTheme.gold,
            height: 1,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
            fontSize: isMobile ? 9 : 11,
            color: AppTheme.textMuted,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }
}

// ─── Add Review Dialog ────────────────────────────────────────
class _AddReviewDialog extends StatefulWidget {
  const _AddReviewDialog();

  @override
  State<_AddReviewDialog> createState() => _AddReviewDialogState();
}

class _AddReviewDialogState extends State<_AddReviewDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _eventCtrl = TextEditingController();
  final _textCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _eventCtrl.dispose();
    _textCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final initials = _nameCtrl.text
        .trim()
        .split(' ')
        .take(2)
        .map((e) => e.isNotEmpty ? e[0] : '')
        .join('.');

    context.read<TestimonialsCubit>().addTestimonial(
          Testimonial(
            name: _nameCtrl.text.trim(),
            event: _eventCtrl.text.trim(),
            text: _textCtrl.text.trim(),
            initials: initials.toUpperCase(),
          ),
        );

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppTheme.surface,
        content: Text(
          'testimonial_success'.tr(),
          style: GoogleFonts.montserrat(color: AppTheme.gold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;
    final isRtl = context.locale.languageCode == 'ar';

    return Dialog(
      backgroundColor: AppTheme.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: AppTheme.border),
        borderRadius: BorderRadius.zero,
      ),
      child: Container(
        width: isMobile ? double.infinity : 500,
        padding: EdgeInsets.all(isMobile ? 24 : 40),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'testimonial_form_title'.tr(),
                  textAlign: isRtl ? TextAlign.right : TextAlign.left,
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: isMobile ? 32 : 40,
                    fontWeight: FontWeight.w300,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'testimonial_form_subtitle'.tr(),
                  textAlign: isRtl ? TextAlign.right : TextAlign.left,
                  style: GoogleFonts.montserrat(
                      fontSize: 12, color: AppTheme.textMuted),
                ),
                const SizedBox(height: 32),
                _buildField('testimonial_form_name'.tr(), _nameCtrl, isRtl),
                const SizedBox(height: 20),
                _buildField('testimonial_form_event'.tr(), _eventCtrl, isRtl),
                const SizedBox(height: 20),
                _buildField('testimonial_form_text'.tr(), _textCtrl, isRtl, maxLines: 4),
                const SizedBox(height: 40),
                Wrap(
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 20,
                  runSpacing: 12,
                  textDirection: isRtl ? ui.TextDirection.rtl : ui.TextDirection.ltr,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        (isRtl ? 'إلغاء' : 'CANCEL').toUpperCase(),
                        style: GoogleFonts.montserrat(
                            fontSize: 11,
                            letterSpacing: 1,
                            color: AppTheme.textDim),
                      ),
                    ),
                    GoldButton(
                      label: 'testimonial_form_submit'.tr(),
                      onTap: _submit,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, bool isRtl,
      {int maxLines = 1}) {
    return Column(
      crossAxisAlignment:  CrossAxisAlignment.start,
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
          textAlign: isRtl ? TextAlign.right : TextAlign.left,
          textDirection: isRtl ? ui.TextDirection.rtl : ui.TextDirection.ltr,
          style: GoogleFonts.montserrat(
              fontSize: 13, color: AppTheme.textPrimary),
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'form_required'.tr() : null,
          decoration: const InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
}

// ─── Testimonial Card ─────────────────────────────────────────
class _TestimonialCard extends StatefulWidget {
  final Testimonial testimonial;
  final int delay;
  const _TestimonialCard({required this.testimonial, this.delay = 0});

  @override
  State<_TestimonialCard> createState() => _TestimonialCardState();
}

class _TestimonialCardState extends State<_TestimonialCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final isRtl = context.locale.languageCode == 'ar';
    
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        transform: Matrix4.translationValues(0, _hover ? -6 : 0, 0),
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          border: Border.all(
              color: _hover ? AppTheme.gold : AppTheme.border),
          boxShadow: _hover
              ? [
                  BoxShadow(
                    color: AppTheme.gold.withOpacity(0.08),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                  )
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: isRtl ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: List.generate(
                widget.testimonial.rating,
                (_) => Padding(
                  padding: EdgeInsets.only(
                    right: isRtl ? 0 : 3,
                    left: isRtl ? 3 : 0,
                  ),
                  child: const Icon(Icons.star, color: AppTheme.gold, size: 14),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '"${widget.testimonial.text}"',
              textAlign: isRtl ? TextAlign.right : TextAlign.left,
              style: GoogleFonts.cormorantGaramond(
                fontSize: 17,
                fontStyle: FontStyle.italic,
                color: AppTheme.textMuted,
                height: 1.7,
              ),
            ),
            const SizedBox(height: 24),
            Container(height: 1, color: AppTheme.border),
            const SizedBox(height: 20),
            Row(
              textDirection: isRtl ? ui.TextDirection.rtl : ui.TextDirection.ltr,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.goldDim,
                    border: Border.all(color: AppTheme.gold, width: 1.5),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    widget.testimonial.initials,
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 16,
                      color: AppTheme.gold,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.testimonial.name,
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 17,
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        widget.testimonial.event,
                        style: GoogleFonts.montserrat(
                          fontSize: 10,
                          color: AppTheme.textDim,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: widget.delay), duration: 700.ms)
        .slideY(begin: 0.1, end: 0);
  }
}
