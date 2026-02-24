import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/section_label.dart';
import '../../../home/presentation/widgets/footer_section.dart';

class TestimonialsScreen extends StatelessWidget {
  const TestimonialsScreen({super.key});

  static final List<Map<String, String>> _testimonials = [
    {
      'name': 'محمد و فاطمة',
      'event': 'فرح نوفمبر 2024',
      'text':
          'ابراهيم مبقاش بس مصور — ده فنان بيحس باللحظة. كل صورة حسينا فيها إحنا تاني مع بعض. التجربة كلها كانت راقية جداً من أول ما دخل لحد ما طلعنا.',
      'initials': 'م.ف',
      'rating': '5',
    },
    {
      'name': 'أحمد و نور',
      'event': 'فرح أكتوبر 2024',
      'text':
          'من أول ما دخلنا الكوشة لحد ما طلعنا، كان موجود في كل حتة. الصور جميلة جداً وبتحكي القصة كلها. الألبوم جه أحسن من توقعاتنا.',
      'initials': 'أ.ن',
      'rating': '5',
    },
    {
      'name': 'كريم و ياسمين',
      'event': 'فرح سبتمبر 2024',
      'text':
          'الألبوم جه أحسن من أي حاجة تخيلتها! شكراً ابراهيم على كل لحظة حلوة اتسجلت. موهبة حقيقية وشخص رائع التعامل معاه.',
      'initials': 'ك.ي',
      'rating': '5',
    },
    {
      'name': 'عمر و سارة',
      'event': 'فرح أغسطس 2024',
      'text':
          'التفاصيل الصغيرة اللي بيلتقطها ابراهيم هي الحاجة اللي بتفرقه عن غيره. موهبة حقيقية وبيحب اللي بيعمله وده بيظهر في كل صورة.',
      'initials': 'ع.س',
      'rating': '5',
    },
    {
      'name': 'يوسف و منى',
      'event': 'فرح يوليو 2024',
      'text':
          'باكدج الفيديو كان قمة! الريل اللي جه نزلناه على الانستا وعمل اتفاعل رهيب. كل حاجة اتسجلت بطريقة سينمائية رائعة.',
      'initials': 'ي.م',
      'rating': '5',
    },
    {
      'name': 'طارق و ريهام',
      'event': 'فرح يونيو 2024',
      'text':
          'من أول ما تعاملنا مع ابراهيم حسينا بالأمان. هو بيعرف يخلي الناس تحس بالراحة قدام الكاميرا وده أهم حاجة. شكراً على كل شيء.',
      'initials': 'ط.ر',
      'rating': '5',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Hero
          Container(
            height: 340,
            color: AppTheme.surface,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 90),
                  const SectionLabel(text: 'Client Stories'),
                  const SizedBox(height: 20),
                  Text(
                    'Testimonials',
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 62,
                      fontWeight: FontWeight.w300,
                      color: AppTheme.textPrimary,
                    ),
                  ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2, end: 0),
                  Text(
                    'ماذا يقول عملاءنا عن تجربتهم',
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      color: AppTheme.textMuted,
                    ),
                  ).animate().fadeIn(delay: 300.ms),
                ],
              ),
            ),
          ),

          // Rating summary
          Container(
            color: AppTheme.bg,
            padding: EdgeInsets.symmetric(
              vertical: 60,
              horizontal: isMobile ? 24 : 80,
            ),
            child: Column(
              children: [
                _RatingSummary(),
                const SizedBox(height: 80),
                const SectionLabel(text: 'Happy Couples'),
                const SizedBox(height: 16),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Real Stories from\n',
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: isMobile ? 36 : 52,
                          fontWeight: FontWeight.w300,
                          color: AppTheme.textPrimary,
                          height: 1.2,
                        ),
                      ),
                      TextSpan(
                        text: 'Real Couples',
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
                const SizedBox(height: 60),

                // Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isMobile ? 1 : 2,
                    crossAxisSpacing: 3,
                    mainAxisSpacing: 3,
                    childAspectRatio: isMobile ? 1.3 : 1.4,
                  ),
                  itemCount: _testimonials.length,
                  itemBuilder: (ctx, i) => _TestimonialCard(
                    data: _testimonials[i],
                    delay: i * 100,
                  ),
                ),
              ],
            ),
          ),

          const FooterSection(),
        ],
      ),
    );
  }
}

class _RatingSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                '5.0',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 72,
                  fontWeight: FontWeight.w300,
                  color: AppTheme.gold,
                  height: 1,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: List.generate(
                  5,
                  (_) => const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2),
                    child: Icon(Icons.star, color: AppTheme.gold, size: 18),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Average Rating',
                style: GoogleFonts.montserrat(
                  fontSize: 11,
                  color: AppTheme.textMuted,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
          Container(width: 1, height: 100, color: AppTheme.border),
          Column(
            children: [
              Text(
                '200+',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 72,
                  fontWeight: FontWeight.w300,
                  color: AppTheme.gold,
                  height: 1,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Happy Couples',
                style: GoogleFonts.montserrat(
                  fontSize: 11,
                  color: AppTheme.textMuted,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
          Container(width: 1, height: 100, color: AppTheme.border),
          Column(
            children: [
              Text(
                '98%',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 72,
                  fontWeight: FontWeight.w300,
                  color: AppTheme.gold,
                  height: 1,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Would Recommend',
                style: GoogleFonts.montserrat(
                  fontSize: 11,
                  color: AppTheme.textMuted,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms);
  }
}

class _TestimonialCard extends StatefulWidget {
  final Map<String, String> data;
  final int delay;
  const _TestimonialCard({required this.data, this.delay = 0});

  @override
  State<_TestimonialCard> createState() => _TestimonialCardState();
}

class _TestimonialCardState extends State<_TestimonialCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final rating = int.tryParse(widget.data['rating'] ?? '5') ?? 5;

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
            color: _hover ? AppTheme.gold : AppTheme.border,
          ),
          boxShadow: _hover
              ? [
                  BoxShadow(
                    color: AppTheme.gold.withOpacity(0.08),
                    blurRadius: 40,
                    spreadRadius: 0,
                    offset: const Offset(0, 20),
                  )
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stars
            Row(
              children: List.generate(
                rating,
                (_) => const Padding(
                  padding: EdgeInsets.only(right: 3),
                  child: Icon(Icons.star, color: AppTheme.gold, size: 14),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Text
            Expanded(
              child: Text(
                '"${widget.data['text']}"',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 17,
                  fontStyle: FontStyle.italic,
                  color: AppTheme.textMuted,
                  height: 1.7,
                ),
              ),
            ),

            const SizedBox(height: 24),
            Container(height: 1, color: AppTheme.border),
            const SizedBox(height: 20),

            // Author
            Row(
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
                    widget.data['initials'] ?? '',
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 16,
                      color: AppTheme.gold,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.data['name'] ?? '',
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 17,
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
    )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: widget.delay),
          duration: 700.ms,
        )
        .slideY(begin: 0.1, end: 0);
  }
}
