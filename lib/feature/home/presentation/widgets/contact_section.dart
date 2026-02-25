import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/section_label.dart';
import '../../../../core/widgets/gold_button.dart';
import '../../../../core/translations/locale_keys.g.dart';

class ContactSection extends StatelessWidget {
  ContactSection({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    context.locale; // Ensure rebuild on locale change
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
    context.locale; // Listen for locale changes
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(text: LocaleKeys.section_contact.tr()),
        const SizedBox(height: 20),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '${LocaleKeys.contact_title_1.tr()}\n',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 42,
                  fontWeight: FontWeight.w300,
                  color: AppTheme.textPrimary,
                  height: 1.2,
                ),
              ),
              TextSpan(
                text: LocaleKeys.contact_title_2.tr(),
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
          label: LocaleKeys.contact_phone_label.tr(),
          value: '01155699971',
          onTap: () => launchUrl(Uri.parse('tel:01155699971')),
        ),
        const SizedBox(height: 24),
        _ContactItem(
          icon: Icons.camera_alt_outlined,
          label: LocaleKeys.contact_social_label.tr(),
          value: '@HEEMA.GAMAL_PH',
          onTap: () => launchUrl(
            Uri.parse('https://www.instagram.com/heema.gamal_ph?igsh=eXhtZmI2a3Z3ODY4&utm_source=qr'),
          ),
        ),
        const SizedBox(height: 24),
        // _ContactItem(
        //   icon: Icons.payment_outlined,
        //   label: LocaleKeys.contact_payment_label.tr(),
        //   value: LocaleKeys.contact_payment_value.tr(),
        //   onTap: null,
        // ),
        // const SizedBox(height: 32),

        // ── خريطة الموقع ─────────────────────────────────────
        _MapCard(),

        const SizedBox(height: 32),
        // Social links
        Row(
          children: [
            _SocialBtn(icon: Icons.camera_alt, onTap: () => launchUrl(
              Uri.parse('https://www.instagram.com/heema.gamal_ph?igsh=eXhtZmI2a3Z3ODY4&utm_source=qr'),
            )),
            const SizedBox(width: 12),
            _SocialBtn(icon: Icons.facebook, onTap: () => launchUrl(
              Uri.parse('https://www.facebook.com/share/1Awgm5KaaY/?mibextid=wwXIfr'),
            )),
          ],
        ),
      ],
    );
  }
}

// ─── Map Card ─────────────────────────────────────────────────
class _MapCard extends StatefulWidget {
  @override
  State<_MapCard> createState() => _MapCardState();
}

class _MapCardState extends State<_MapCard> {
  bool _hover = false;

  static const _locationQuery = '25 شارع الشركات الزاوية الحمراء القاهرة';
  static const _webMapsUrl = 'https://www.google.com/maps/search/?api=1&query=25+%D8%B4%D8%A7%D8%B1%D8%B9+%D8%A7%D9%84%D8%B4%D8%B1%D9%83%D8%A7%D8%AA+%D8%A7%D9%84%D8%B2%D8%A7%D9%88%D9%8A%D8%A9+%D8%A7%D9%84%D8%AD%D9%85%D8%B1%D8%A7%D8%A1+%D8%A7%D9%84%D9%82%D8%A7%D9%87%D8%B1%D8%A9';

  Future<void> _openMaps() async {
    final geoUri = Uri.parse('geo:0,0?q=$_locationQuery');
    final webUri = Uri.parse(_webMapsUrl);

    try {
      // Try native maps first (Android/iOS)
      if (await canLaunchUrl(geoUri)) {
        await launchUrl(geoUri);
      } else {
        // Fallback to web browser
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      // Last resort fallback
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRtl = context.locale.languageCode == 'ar';
    
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: _openMaps,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            border: Border(
              left: isRtl 
                ? BorderSide(color: AppTheme.border)
                : BorderSide(color: _hover ? AppTheme.gold : AppTheme.border, width: 3),
              right: isRtl
                ? BorderSide(color: _hover ? AppTheme.gold : AppTheme.border, width: 3)
                : BorderSide(color: AppTheme.border),
              top: BorderSide(color: AppTheme.border),
              bottom: BorderSide(color: AppTheme.border),
            ),
            boxShadow: _hover
                ? [
                    BoxShadow(
                      color: AppTheme.gold.withOpacity(0.08),
                      blurRadius: 20,
                    )
                  ]
                : [],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.goldDim,
                      border: Border.all(color: AppTheme.gold),
                    ),
                    child: const Icon(
                      Icons.location_on_outlined,
                      color: AppTheme.gold,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.location_title.tr().toUpperCase(),
                          style: GoogleFonts.montserrat(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                            color: AppTheme.textDim,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          LocaleKeys.location_address.tr(),
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            color: AppTheme.textMuted,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // Map preview visual
              Container(
                height: 90,
                decoration: BoxDecoration(
                  color: AppTheme.bg,
                  border: Border.all(color: AppTheme.border),
                ),
                child: Stack(
                  children: [
                    // Decorative grid
                    ...List.generate(5, (i) => Positioned(
                      left: 0, right: 0,
                      top: i * 18.0,
                      child: Container(height: 1, color: AppTheme.border),
                    )),
                    ...List.generate(7, (i) => Positioned(
                      top: 0, bottom: 0,
                      left: i * 46.0,
                      child: Container(width: 1, color: AppTheme.border),
                    )),
                    // Pin
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              color: AppTheme.gold,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.location_on,
                              color: AppTheme.bg,
                              size: 18,
                            ),
                          ),
                          Container(
                            width: 2,
                            height: 10,
                            color: AppTheme.gold,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Open Maps button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                   Text(
                    LocaleKeys.location_open_maps.tr(),
                    style: GoogleFonts.montserrat(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _hover ? AppTheme.gold : AppTheme.textDim,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.open_in_new,
                    size: 14,
                    color: _hover ? AppTheme.gold : AppTheme.textDim,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
      'basic': '${LocaleKeys.nav_packages.tr()} 1 — ${LocaleKeys.pkg_1_name.tr()} (${LocaleKeys.pkg_1_duration.tr()}) - 2500 LE',
      'half':  '${LocaleKeys.nav_packages.tr()} 2 — ${LocaleKeys.pkg_2_name.tr()} (${LocaleKeys.pkg_2_duration.tr()}) - 3500 LE',
      'full':  '${LocaleKeys.nav_packages.tr()} 3 — ${LocaleKeys.pkg_3_name.tr()} (${LocaleKeys.pkg_3_duration.tr()}) - 4000 LE',
    }[_selectedPackage] ?? '—';

    final message = '''
${LocaleKeys.whatsapp_msg_title.tr()}

${(context.locale.languageCode == 'ar' ? '*الاسم:* ' : '*Name:* ')} ${_nameCtrl.text.trim()}
${(context.locale.languageCode == 'ar' ? '*رقم الهاتف:* ' : '*Phone:* ')} ${_phoneCtrl.text.trim()}
${LocaleKeys.whatsapp_msg_date.tr()} ${_dateCtrl.text.trim()}
${LocaleKeys.whatsapp_msg_pkg.tr()} $packageLabel
${(context.locale.languageCode == 'ar' ? '*رسالة:* ' : '*Message:* ')} ${_messageCtrl.text.trim().isEmpty ? '—' : _messageCtrl.text.trim()}
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
                  LocaleKeys.form_success.tr(),
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
              LocaleKeys.form_error.tr(),
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
    context.locale; // Listen for locale changes
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── العنوان ─────────────────────────────────────────
          Text(
            LocaleKeys.form_title.tr(),
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
                LocaleKeys.form_hint.tr(),
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
                label: LocaleKeys.form_name.tr(),
                hint: LocaleKeys.form_name_hint.tr(),
                controller: _nameCtrl,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? LocaleKeys.form_name_error.tr() : null,
              )),
              const SizedBox(width: 20),
              Expanded(child: _buildField(
                label: LocaleKeys.form_phone.tr(),
                hint: '01xxxxxxxxx',
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                validator: (v) => (v == null || v.trim().length < 10)
                    ? LocaleKeys.form_phone_error.tr() : null,
              )),
            ],
          ),
          const SizedBox(height: 20),

          // ── تاريخ الفرح ──────────────────────────────────────
          _buildDateField(),
          const SizedBox(height: 20),

          // ── الباكدج ──────────────────────────────────────────
          _buildDropdown(),
          const SizedBox(height: 20),

          // ── رسالة إضافية ─────────────────────────────────────
          _buildField(
            label: LocaleKeys.form_message.tr(),
            hint: LocaleKeys.form_message_hint.tr(),
            controller: _messageCtrl,
            multiline: true,
          ),
          const SizedBox(height: 32),

          // ── زرار الإرسال ─────────────────────────────────────
          GoldButton(
            label: _sending ? LocaleKeys.form_sending.tr() : LocaleKeys.form_send_btn.tr(),
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

  /// حقل التاريخ — بيفتح Calendar Dialog
  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.form_date.tr().toUpperCase(),
          style: GoogleFonts.montserrat(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
            color: AppTheme.textMuted,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now().add(const Duration(days: 30)),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 730)),
              builder: (ctx, child) => Theme(
                data: Theme.of(ctx).copyWith(
                  colorScheme: ColorScheme.dark(
                    primary: AppTheme.gold,
                    onPrimary: AppTheme.bg,
                    surface: AppTheme.surface,
                    onSurface: AppTheme.textPrimary,
                  ),
                  dialogBackgroundColor: AppTheme.surface,
                ),
                child: child!,
              ),
            );
            if (picked != null) {
              _dateCtrl.text =
                  DateFormat('EEEE, d MMMM yyyy').format(picked);
            }
          },
          child: AbsorbPointer(
            child: TextFormField(
              controller: _dateCtrl,
              readOnly: true,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? LocaleKeys.form_date_error.tr() : null,
              style: GoogleFonts.montserrat(
                fontSize: 13,
                color: AppTheme.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: LocaleKeys.form_date_hint.tr(),
                suffixIcon: const Icon(
                  Icons.calendar_today_outlined,
                  color: AppTheme.gold,
                  size: 18,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.form_package.tr().toUpperCase(),
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
            LocaleKeys.form_package_hint.tr(),
            style: GoogleFonts.montserrat(
              fontSize: 13,
              color: AppTheme.textDim,
            ),
          ),
          validator: (v) => v == null ? LocaleKeys.form_package_error.tr() : null,
          items: [
            DropdownMenuItem(
                value: 'basic',
                child: Text('${LocaleKeys.nav_packages.tr()} 1 — ${LocaleKeys.pkg_1_name.tr()} (2500 LE)')),
            DropdownMenuItem(
                value: 'half',
                child: Text('${LocaleKeys.nav_packages.tr()} 2 — ${LocaleKeys.pkg_2_name.tr()} (3500 LE)')),
            DropdownMenuItem(
                value: 'full',
                child: Text('${LocaleKeys.nav_packages.tr()} 3 — ${LocaleKeys.pkg_3_name.tr()} (4000 LE)')),
          ],
          onChanged: (v) => setState(() => _selectedPackage = v),
        ),
      ],
    );
  }
}

