import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/section_label.dart';
import '../../../../core/widgets/gold_button.dart';

class ContactSection extends StatelessWidget {
  ContactSection({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Container(
      color: AppTheme.bgAlt,
      padding: EdgeInsets.symmetric(
        vertical: 100,
        horizontal: isMobile ? 24 : 80,
      ),
      child: isMobile
          ? Column(children: [_ContactInfo(), const SizedBox(height: 60), _ContactForm(formKey: _formKey)])
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _ContactInfo()),
                const SizedBox(width: 80),
                Expanded(flex: 2, child: _ContactForm(formKey: _formKey)),
              ],
            ),
    );
  }
}

class _ContactInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel(text: 'Contact'),
        const SizedBox(height: 20),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Let\'s Create\n',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 42,
                  fontWeight: FontWeight.w300,
                  color: AppTheme.textPrimary,
                  height: 1.2,
                ),
              ),
              TextSpan(
                text: 'Together',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 42,
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
        _ContactItem(
          icon: Icons.phone_outlined,
          label: 'Phone / WhatsApp',
          value: '01155699971',
          onTap: () => launchUrl(Uri.parse('tel:01155699971')),
        ),
        const SizedBox(height: 24),
        _ContactItem(
          icon: Icons.camera_alt_outlined,
          label: 'Instagram & Facebook',
          value: '@HEEMA.GAMALPH',
          onTap: () => launchUrl(
            Uri.parse('https://instagram.com/heema.gamalph'),
          ),
        ),
        const SizedBox(height: 24),
        _ContactItem(
          icon: Icons.payment_outlined,
          label: 'Booking & Payment',
          value: 'Instagram DM أو كاش / فودافون كاش',
          onTap: null,
        ),
        const SizedBox(height: 40),
        // Social links
        Row(
          children: [
            _SocialBtn(icon: Icons.camera_alt, onTap: () => launchUrl(
              Uri.parse('https://instagram.com/heema.gamalph'),
            )),
            const SizedBox(width: 12),
            _SocialBtn(icon: Icons.facebook, onTap: () => launchUrl(
              Uri.parse('https://facebook.com/HEEMA.GAMALPH'),
            )),
          ],
        ),
      ],
    );
  }
}

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  const _ContactItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.goldDim,
              border: Border.all(color: AppTheme.gold),
            ),
            child: Icon(icon, color: AppTheme.gold, size: 20),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: GoogleFonts.montserrat(
                    fontSize: 9,
                    letterSpacing: 0.2,
                    color: AppTheme.textDim,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 18,
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialBtn extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _SocialBtn({required this.icon, required this.onTap});

  @override
  State<_SocialBtn> createState() => _SocialBtnState();
}

class _SocialBtnState extends State<_SocialBtn> {
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
          duration: const Duration(milliseconds: 300),
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: _hover ? AppTheme.gold : Colors.transparent,
            border: Border.all(color: _hover ? AppTheme.gold : AppTheme.border),
          ),
          child: Icon(
            widget.icon,
            color: _hover ? AppTheme.bg : AppTheme.textMuted,
            size: 18,
          ),
        ),
      ),
    );
  }
}

class _ContactForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const _ContactForm({required this.formKey});

  @override
  State<_ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<_ContactForm> {
  final _nameCtrl    = TextEditingController();
  final _phoneCtrl   = TextEditingController();
  final _dateCtrl    = TextEditingController();
  final _messageCtrl = TextEditingController();
  String? _selectedPackage;
  bool _sending = false;

  // ── رقم الواتساب بتاعك ──────────────────────────────────────
  static const _whatsappNumber = '201155699971'; // 20 = كود مصر

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _dateCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendWhatsApp() async {
    if (!widget.formKey.currentState!.validate()) return;

    setState(() => _sending = true);

    // ── بناء الرسالة ─────────────────────────────────────────
    final packageLabel = {
      'basic': 'Package 1 — Basic (2500 LE)',
      'half':  'Package 2 — Half Day (3500 LE)',
      'full':  'Package 3 — Full Day (4000 LE)',
    }[_selectedPackage] ?? 'لم يتم الاختيار';

    final message = '''
🌹 *طلب حجز جديد — iBrahiim Photography*

👤 *الاسم:* ${_nameCtrl.text.trim()}
📱 *رقم الهاتف:* ${_phoneCtrl.text.trim()}
📅 *تاريخ الفرح:* ${_dateCtrl.text.trim()}
📦 *الباكدج:* $packageLabel
💬 *رسالة:* ${_messageCtrl.text.trim().isEmpty ? '—' : _messageCtrl.text.trim()}
    '''.trim();

    // ── فتح واتساب ───────────────────────────────────────────
    final encoded = Uri.encodeComponent(message);
    final url = 'https://wa.me/$_whatsappNumber?text=$encoded';

    try {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
      // ── مسح الفورم بعد الإرسال ────────────────────────────
      if (mounted) {
        _nameCtrl.clear();
        _phoneCtrl.clear();
        _dateCtrl.clear();
        _messageCtrl.clear();
        setState(() => _selectedPackage = null);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppTheme.surface,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(20),
            content: Row(
              children: [
                const Icon(Icons.check_circle_outline,
                    color: AppTheme.gold, size: 20),
                const SizedBox(width: 12),
                Text(
                  'تم فتح واتساب! رسالتك جاهزة للإرسال ✅',
                  style: GoogleFonts.montserrat(color: AppTheme.gold),
                ),
              ],
            ),
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppTheme.surface,
            content: Text(
              'تعذّر فتح واتساب. تأكد إن التطبيق مثبّت.',
              style: GoogleFonts.montserrat(color: Colors.redAccent),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── العنوان ─────────────────────────────────────────
          Text(
            'Send via WhatsApp',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 32,
              fontWeight: FontWeight.w300,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.chat_outlined, color: Color(0xFF25D366), size: 18),
              const SizedBox(width: 8),
              Text(
                'ابعتلنا رسالة على واتساب مباشرة',
                style: GoogleFonts.montserrat(
                  fontSize: 13,
                  color: AppTheme.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),

          // ── الاسم + التليفون ─────────────────────────────────
          Row(
            children: [
              Expanded(child: _buildField(
                label: 'Full Name',
                hint: 'اسمك الكامل',
                controller: _nameCtrl,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'الاسم مطلوب' : null,
              )),
              const SizedBox(width: 20),
              Expanded(child: _buildField(
                label: 'Phone',
                hint: '01xxxxxxxxx',
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                validator: (v) => (v == null || v.trim().length < 10)
                    ? 'رقم غير صحيح' : null,
              )),
            ],
          ),
          const SizedBox(height: 20),

          // ── تاريخ الفرح ──────────────────────────────────────
          _buildField(
            label: 'Wedding Date',
            hint: 'مثال: 15 مارس 2025',
            controller: _dateCtrl,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'التاريخ مطلوب' : null,
          ),
          const SizedBox(height: 20),

          // ── الباكدج ──────────────────────────────────────────
          _buildDropdown(),
          const SizedBox(height: 20),

          // ── رسالة إضافية ─────────────────────────────────────
          _buildField(
            label: 'Message',
            hint: 'أي تفاصيل إضافية... (اختياري)',
            controller: _messageCtrl,
            multiline: true,
          ),
          const SizedBox(height: 32),

          // ── زرار الإرسال ─────────────────────────────────────
          GoldButton(
            label: _sending ? 'جاري الفتح...' : 'إرسال على واتساب',
            onTap: _sending ? null : _sendWhatsApp,
            icon: Icons.chat_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool multiline = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.montserrat(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
            color: AppTheme.textMuted,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: multiline ? 4 : 1,
          keyboardType: keyboardType,
          validator: validator,
          style: GoogleFonts.montserrat(
            fontSize: 13,
            color: AppTheme.textPrimary,
          ),
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }

  Widget _buildDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PACKAGE',
          style: GoogleFonts.montserrat(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
            color: AppTheme.textMuted,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedPackage,
          dropdownColor: AppTheme.surface,
          style: GoogleFonts.montserrat(
            fontSize: 13,
            color: AppTheme.textPrimary,
          ),
          decoration: const InputDecoration(),
          hint: Text(
            'اختار الباكدج',
            style: GoogleFonts.montserrat(
              fontSize: 13,
              color: AppTheme.textDim,
            ),
          ),
          validator: (v) => v == null ? 'اختار الباكدج' : null,
          items: const [
            DropdownMenuItem(
                value: 'basic',
                child: Text('Package 1 — Basic (2500 LE)')),
            DropdownMenuItem(
                value: 'half',
                child: Text('Package 2 — Half Day (3500 LE)')),
            DropdownMenuItem(
                value: 'full',
                child: Text('Package 3 — Full Day (4000 LE)')),
          ],
          onChanged: (v) => setState(() => _selectedPackage = v),
        ),
      ],
    );
  }
}

