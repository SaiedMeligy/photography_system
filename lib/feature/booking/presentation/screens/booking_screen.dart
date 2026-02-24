import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/section_label.dart';
import '../../../../core/widgets/gold_button.dart';
import '../../../home/presentation/widgets/footer_section.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String _selectedPackage = '';
  String _selectedPayment = 'cash';
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Simulated booked dates
  final Set<DateTime> _bookedDates = {
    DateTime.now().add(const Duration(days: 3)),
    DateTime.now().add(const Duration(days: 7)),
    DateTime.now().add(const Duration(days: 14)),
    DateTime.now().add(const Duration(days: 21)),
    DateTime.now().add(const Duration(days: 28)),
  };

  bool _isBooked(DateTime day) => _bookedDates.any((d) =>
      d.year == day.year && d.month == day.month && d.day == day.day);

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _submitBooking() {
    if (_selectedDay == null) {
      _showSnack('من فضلك اختار تاريخ الفرح أولاً 📅', isError: true);
      return;
    }
    if (_selectedPackage.isEmpty) {
      _showSnack('من فضلك اختار الباكدج 📦', isError: true);
      return;
    }
    if (_nameCtrl.text.isEmpty || _phoneCtrl.text.isEmpty) {
      _showSnack('من فضلك أدخل اسمك ورقمك 📝', isError: true);
      return;
    }
    _showSnack(
      'تم الحجز! هنتواصل معاك على ${_phoneCtrl.text} لتأكيد العربون 🎉',
      isError: false,
    );
  }

  void _showSnack(String msg, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError ? const Color(0xFF3A1A1A) : AppTheme.surface,
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: isError ? Colors.redAccent : AppTheme.gold,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                msg,
                style: GoogleFonts.montserrat(
                  color: isError ? Colors.redAccent : AppTheme.gold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Hero
          _BookingHero(),

          Container(
            color: AppTheme.bgAlt,
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 24 : 80,
              vertical: 100,
            ),
            child: Column(
              children: [
                if (isMobile) ...[
                  _CalendarSection(
                    focusedDay: _focusedDay,
                    selectedDay: _selectedDay,
                    bookedDates: _bookedDates,
                    isBooked: _isBooked,
                    onDaySelected: (sel, foc) =>
                        setState(() {
                          _selectedDay = sel;
                          _focusedDay = foc;
                        }),
                    onPageChanged: (d) => setState(() => _focusedDay = d),
                  ),
                  const SizedBox(height: 50),
                  _BookingForm(
                    formKey: _formKey,
                    nameCtrl: _nameCtrl,
                    phoneCtrl: _phoneCtrl,
                    emailCtrl: _emailCtrl,
                    notesCtrl: _notesCtrl,
                    selectedDay: _selectedDay,
                    selectedPackage: _selectedPackage,
                    selectedPayment: _selectedPayment,
                    onPackageChanged: (v) => setState(() => _selectedPackage = v!),
                    onPaymentChanged: (v) => setState(() => _selectedPayment = v),
                    onSubmit: _submitBooking,
                  ),
                ] else ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _CalendarSection(
                          focusedDay: _focusedDay,
                          selectedDay: _selectedDay,
                          bookedDates: _bookedDates,
                          isBooked: _isBooked,
                          onDaySelected: (sel, foc) =>
                              setState(() {
                                _selectedDay = sel;
                                _focusedDay = foc;
                              }),
                          onPageChanged: (d) =>
                              setState(() => _focusedDay = d),
                        ),
                      ),
                      const SizedBox(width: 60),
                      Expanded(
                        flex: 2,
                        child: _BookingForm(
                          formKey: _formKey,
                          nameCtrl: _nameCtrl,
                          phoneCtrl: _phoneCtrl,
                          emailCtrl: _emailCtrl,
                          notesCtrl: _notesCtrl,
                          selectedDay: _selectedDay,
                          selectedPackage: _selectedPackage,
                          selectedPayment: _selectedPayment,
                          onPackageChanged: (v) =>
                              setState(() => _selectedPackage = v!),
                          onPaymentChanged: (v) =>
                              setState(() => _selectedPayment = v),
                          onSubmit: _submitBooking,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          const FooterSection(),
        ],
      ),
    );
  }
}

// ─── Booking Hero ─────────────────────────────────────────────
class _BookingHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 340,
      color: AppTheme.surface,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 90),
            const SectionLabel(text: 'Reserve Your Day'),
            const SizedBox(height: 20),
            Text(
              'Book a Date',
              style: GoogleFonts.cormorantGaramond(
                fontSize: 62,
                fontWeight: FontWeight.w300,
                color: AppTheme.textPrimary,
              ),
            ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2, end: 0),
            Text(
              'احجز يومك قبل ما الميعاد يتحجز',
              style: GoogleFonts.montserrat(
                fontSize: 13,
                color: AppTheme.textMuted,
                letterSpacing: 0.1,
              ),
            ).animate().fadeIn(delay: 300.ms),
          ],
        ),
      ),
    );
  }
}

// ─── Calendar Section ─────────────────────────────────────────
class _CalendarSection extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final Set<DateTime> bookedDates;
  final bool Function(DateTime) isBooked;
  final void Function(DateTime, DateTime) onDaySelected;
  final void Function(DateTime) onPageChanged;

  const _CalendarSection({
    required this.focusedDay,
    required this.selectedDay,
    required this.bookedDates,
    required this.isBooked,
    required this.onDaySelected,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            focusedDay: focusedDay,
            selectedDayPredicate: (day) => isSameDay(selectedDay, day),
            enabledDayPredicate: (day) =>
                !isBooked(day) && day.isAfter(DateTime.now().subtract(const Duration(days: 1))),
            onDaySelected: onDaySelected,
            onPageChanged: onPageChanged,
            calendarStyle: CalendarStyle(
              defaultTextStyle: GoogleFonts.montserrat(
                fontSize: 13,
                color: AppTheme.textMuted,
              ),
              weekendTextStyle: GoogleFonts.montserrat(
                fontSize: 13,
                color: AppTheme.textMuted,
              ),
              todayDecoration: BoxDecoration(
                border: Border.all(color: AppTheme.gold),
                shape: BoxShape.circle,
              ),
              todayTextStyle: GoogleFonts.montserrat(
                fontSize: 13,
                color: AppTheme.gold,
                fontWeight: FontWeight.w600,
              ),
              selectedDecoration: const BoxDecoration(
                color: AppTheme.gold,
                shape: BoxShape.circle,
              ),
              selectedTextStyle: GoogleFonts.montserrat(
                fontSize: 13,
                color: AppTheme.bg,
                fontWeight: FontWeight.w600,
              ),
              disabledTextStyle: GoogleFonts.montserrat(
                fontSize: 13,
                color: AppTheme.textDim,
                decoration: TextDecoration.lineThrough,
              ),
              outsideDaysVisible: false,
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: GoogleFonts.cormorantGaramond(
                fontSize: 22,
                fontWeight: FontWeight.w400,
                color: AppTheme.textPrimary,
              ),
              leftChevronIcon: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.border),
                ),
                child: const Icon(
                  Icons.chevron_left,
                  color: AppTheme.textMuted,
                  size: 18,
                ),
              ),
              rightChevronIcon: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.border),
                ),
                child: const Icon(
                  Icons.chevron_right,
                  color: AppTheme.textMuted,
                  size: 18,
                ),
              ),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: GoogleFonts.montserrat(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.15,
                color: AppTheme.textDim,
              ),
              weekendStyle: GoogleFonts.montserrat(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.15,
                color: AppTheme.textDim,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Legend
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Container(
              height: 1,
              color: AppTheme.border,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _LegendItem(color: AppTheme.gold, label: 'Available'),
              _LegendItem(color: Colors.redAccent.withOpacity(0.5), label: 'Booked'),
              _LegendItem(color: AppTheme.textDim, label: 'Unavailable'),
            ],
          ),

          if (selectedDay != null) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.goldDim,
                border: Border.all(color: AppTheme.gold),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline, color: AppTheme.gold, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    'Selected: ${DateFormat('EEEE, d MMMM yyyy').format(selectedDay!)}',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: AppTheme.gold,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 700.ms).slideX(begin: -0.05, end: 0);
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 10,
            color: AppTheme.textDim,
          ),
        ),
      ],
    );
  }
}

// ─── Booking Form ─────────────────────────────────────────────
class _BookingForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController notesCtrl;
  final DateTime? selectedDay;
  final String selectedPackage;
  final String selectedPayment;
  final void Function(String?) onPackageChanged;
  final void Function(String) onPaymentChanged;
  final VoidCallback onSubmit;

  const _BookingForm({
    required this.formKey,
    required this.nameCtrl,
    required this.phoneCtrl,
    required this.emailCtrl,
    required this.notesCtrl,
    required this.selectedDay,
    required this.selectedPackage,
    required this.selectedPayment,
    required this.onPackageChanged,
    required this.onPaymentChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Request a Booking',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 38,
              fontWeight: FontWeight.w300,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'أدخل بياناتك وهنتواصل معاك لتأكيد الحجز ودفع العربون',
            style: GoogleFonts.montserrat(
              fontSize: 13,
              color: AppTheme.textMuted,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 36),

          // Date selection indicator
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FieldLabel('Selected Date'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  border: Border.all(color: AppTheme.border),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        color: AppTheme.gold, size: 16),
                    const SizedBox(width: 12),
                    Text(
                      selectedDay != null
                          ? DateFormat('EEEE, d MMMM yyyy').format(selectedDay!)
                          : 'اختار التاريخ من التقويم ←',
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        color: selectedDay != null
                            ? AppTheme.gold
                            : AppTheme.textDim,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Name & Phone
          Row(
            children: [
              Expanded(child: _buildField('Full Name', 'اسمك الكريم', nameCtrl)),
              const SizedBox(width: 16),
              Expanded(child: _buildField('Phone', '01xxxxxxxxx', phoneCtrl)),
            ],
          ),
          const SizedBox(height: 20),

          _buildField('Email (Optional)', 'example@email.com', emailCtrl),
          const SizedBox(height: 20),

          // Package
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FieldLabel('Package'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedPackage.isEmpty ? null : selectedPackage,
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
                items: [
                  DropdownMenuItem(
                    value: 'basic',
                    child: Text('Package 1 — Basic (1 ساعة) - 2500 LE'),
                  ),
                  DropdownMenuItem(
                    value: 'half',
                    child: Text('Package 2 — Half Day (6 ساعات) - 3500 LE'),
                  ),
                  DropdownMenuItem(
                    value: 'full',
                    child: Text('Package 3 — Full Day (12 ساعة) - 4000 LE'),
                  ),
                ],
                onChanged: onPackageChanged,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Notes
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FieldLabel('Additional Notes'),
              const SizedBox(height: 8),
              TextFormField(
                controller: notesCtrl,
                maxLines: 4,
                style: GoogleFonts.montserrat(
                  fontSize: 13,
                  color: AppTheme.textPrimary,
                ),
                decoration: const InputDecoration(
                  hintText: 'أي تفاصيل إضافية، مكان الفرح، وقت محدد...',
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Payment method
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              border: Border.all(color: AppTheme.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DEPOSIT PAYMENT METHOD',
                  style: GoogleFonts.montserrat(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.25,
                    color: AppTheme.gold,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _PaymentBtn(
                      label: '💵 Cash',
                      value: 'cash',
                      selected: selectedPayment,
                      onTap: () => onPaymentChanged('cash'),
                    ),
                    _PaymentBtn(
                      label: '📱 Vodafone Cash',
                      value: 'vodafone',
                      selected: selectedPayment,
                      onTap: () => onPaymentChanged('vodafone'),
                    ),
                    _PaymentBtn(
                      label: '💳 Credit Card',
                      value: 'card',
                      selected: selectedPayment,
                      onTap: () => onPaymentChanged('card'),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  '* يتم دفع العربون (30% من قيمة الباكدج) لتأكيد الحجز رسمياً.',
                  style: GoogleFonts.montserrat(
                    fontSize: 11,
                    color: AppTheme.textDim,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          GoldButton(
            label: 'Confirm Booking',
            onTap: onSubmit,
            icon: Icons.calendar_today_outlined,
          ),

          const SizedBox(height: 16),
          Text(
            '* لو عندك سؤال أو محتاج تكلمنا مباشرة: 01155699971',
            style: GoogleFonts.montserrat(
              fontSize: 11,
              color: AppTheme.textDim,
              height: 1.6,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 700.ms).slideX(begin: 0.05, end: 0);
  }

  Widget _buildField(String label, String hint, TextEditingController ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        const SizedBox(height: 8),
        TextFormField(
          controller: ctrl,
          style: GoogleFonts.montserrat(
            fontSize: 13,
            color: AppTheme.textPrimary,
          ),
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: GoogleFonts.montserrat(
        fontSize: 9,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: AppTheme.textMuted,
      ),
    );
  }
}

class _PaymentBtn extends StatelessWidget {
  final String label;
  final String value;
  final String selected;
  final VoidCallback onTap;

  const _PaymentBtn({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selected == value;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.goldDim : AppTheme.bg,
          border: Border.all(
            color: isSelected ? AppTheme.gold : AppTheme.border,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 12,
            color: isSelected ? AppTheme.gold : AppTheme.textMuted,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w300,
          ),
        ),
      ),
    );
  }
}
