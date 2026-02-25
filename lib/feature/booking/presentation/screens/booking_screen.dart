import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/section_label.dart';
import '../../../../core/widgets/gold_button.dart';
import 'dart:ui' as ui;

import '../../cubit/booking_cubit.dart';
import '../../../home/presentation/widgets/footer_section.dart';
import '../../../../core/translations/locale_keys.g.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookingCubit(),
      child: const _BookingView(),
    );
  }
}

// ─── Main View ────────────────────────────────────────────────
class _BookingView extends StatelessWidget {
  const _BookingView();

  static const _whatsappNumber = '201155699971';

  Future<void> _submitBooking(BuildContext context, BookingState state) async {
    if (state.selectedDay == null) {
      _showSnack(context, LocaleKeys.booking_err_date.tr(), isError: true);
      return;
    }
    if (state.selectedPackage.isEmpty) {
      _showSnack(context, LocaleKeys.booking_err_pkg.tr(), isError: true);
      return;
    }

    final packageLabel = {
      'basic': '${LocaleKeys.nav_packages.tr()} 1 — ${LocaleKeys.pkg_1_name.tr()} (${LocaleKeys.pkg_1_duration.tr()}) - 2500 LE',
      'half': '${LocaleKeys.nav_packages.tr()} 2 — ${LocaleKeys.pkg_2_name.tr()} (${LocaleKeys.pkg_2_duration.tr()}) - 3500 LE',
      'full': '${LocaleKeys.nav_packages.tr()} 3 — ${LocaleKeys.pkg_3_name.tr()} (${LocaleKeys.pkg_3_duration.tr()}) - 4000 LE',
    }[state.selectedPackage] ?? state.selectedPackage;

    final dateFormatted =
        DateFormat('EEEE, d MMMM yyyy').format(state.selectedDay!);

    final message = '''
${LocaleKeys.whatsapp_msg_title.tr()}

${LocaleKeys.whatsapp_msg_date.tr()} $dateFormatted
${LocaleKeys.whatsapp_msg_pkg.tr()} $packageLabel
    '''.trim();

    final url =
        'https://wa.me/$_whatsappNumber?text=${Uri.encodeComponent(message)}';

    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      if (context.mounted) {
        _showSnack(context, LocaleKeys.booking_success.tr(), isError: false);
      }
    } catch (_) {
      if (context.mounted) {
        _showSnack(context, LocaleKeys.form_error.tr(), isError: true);
      }
    }
  }

  void _showSnack(BuildContext context, String msg, {required bool isError}) {
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
    final isRtl = context.locale.languageCode == 'ar';

    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              _BookingHero(),

              Container(
                color: AppTheme.bgAlt,
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 24 : 80,
                  vertical: 100,
                ),
                child: isMobile
                    ? Column(
                        children: [
                          _CalendarSection(state: state),
                          const SizedBox(height: 50),
                          _BookingForm(
                            state: state,
                            onSubmit: () => _submitBooking(context, state),
                          ),
                        ],
                      )
                    : Row(
                        textDirection: isRtl ? ui.TextDirection.rtl : ui.TextDirection.ltr,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _CalendarSection(state: state)),
                          const SizedBox(width: 60),
                          Expanded(
                            flex: 2,
                            child: _BookingForm(
                              state: state,
                              onSubmit: () => _submitBooking(context, state),
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

// ─── Hero ─────────────────────────────────────────────────────
class _BookingHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isRtl = context.locale.languageCode == 'ar';
    return Container(
      height: 340,
      color: AppTheme.surface,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 90),
            SectionLabel(text: LocaleKeys.booking_hero_label.tr()),
            const SizedBox(height: 20),
            Text(
              LocaleKeys.booking_hero_title.tr(),
              textAlign: TextAlign.center,
              style: GoogleFonts.cormorantGaramond(
                fontSize: 62,
                fontWeight: FontWeight.w300,
                color: AppTheme.textPrimary,
              ),
            ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2, end: 0),
            Text(
              LocaleKeys.booking_hero_subtitle.tr(),
              textAlign: TextAlign.center,
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
  final BookingState state;
  const _CalendarSection({required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BookingCubit>();
    final isRtl = context.locale.languageCode == 'ar';

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          TableCalendar(
            locale: context.locale.languageCode,
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            focusedDay: state.focusedDay,
            selectedDayPredicate: (day) => isSameDay(state.selectedDay, day),
            enabledDayPredicate: (day) =>
                !state.isBooked(day) &&
                day.isAfter(DateTime.now().subtract(const Duration(days: 1))),
            onDaySelected: cubit.selectDay,
            onPageChanged: cubit.changePage,
            calendarStyle: CalendarStyle(
              defaultTextStyle: GoogleFonts.montserrat(
                  fontSize: 13, color: AppTheme.textMuted),
              weekendTextStyle: GoogleFonts.montserrat(
                  fontSize: 13, color: AppTheme.textMuted),
              todayDecoration: BoxDecoration(
                border: Border.all(color: AppTheme.gold),
                shape: BoxShape.circle,
              ),
              todayTextStyle: GoogleFonts.montserrat(
                  fontSize: 13,
                  color: AppTheme.gold,
                  fontWeight: FontWeight.w600),
              selectedDecoration: const BoxDecoration(
                color: AppTheme.gold,
                shape: BoxShape.circle,
              ),
              selectedTextStyle: GoogleFonts.montserrat(
                  fontSize: 13,
                  color: AppTheme.bg,
                  fontWeight: FontWeight.w600),
              disabledTextStyle: GoogleFonts.montserrat(
                  fontSize: 13,
                  color: AppTheme.textDim,
                  decoration: TextDecoration.lineThrough),
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
              leftChevronIcon: _CalendarChevron(icon: isRtl ? Icons.chevron_right : Icons.chevron_left),
              rightChevronIcon: _CalendarChevron(icon: isRtl ? Icons.chevron_left : Icons.chevron_right),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: GoogleFonts.montserrat(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.15,
                  color: AppTheme.textDim),
              weekendStyle: GoogleFonts.montserrat(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.15,
                  color: AppTheme.textDim),
            ),
          ),
          const SizedBox(height: 20),
          Container(height: 1, color: AppTheme.border),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            alignment: isRtl ? WrapAlignment.end : WrapAlignment.start,
            children: [
              _LegendItem(color: AppTheme.gold, label: LocaleKeys.calendar_available.tr()),
              _LegendItem(
                  color: Colors.redAccent.withOpacity(0.5),
                  label: LocaleKeys.calendar_booked.tr()),
              _LegendItem(
                  color: AppTheme.textDim,
                  label: LocaleKeys.calendar_unavailable.tr()),
            ],
          ),
          if (state.selectedDay != null) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.goldDim,
                border: Border.all(color: AppTheme.gold),
              ),
              child: Row(
                textDirection: isRtl ? ui.TextDirection.rtl : ui.TextDirection.ltr,
                children: [
                  const Icon(Icons.check_circle_outline,
                      color: AppTheme.gold, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    DateFormat('EEEE, d MMMM yyyy', context.locale.languageCode).format(state.selectedDay!),
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
    ).animate().fadeIn(duration: 700.ms).slideX(begin: isRtl ? 0.05 : -0.05, end: 0);
  }
}

class _CalendarChevron extends StatelessWidget {
  final IconData icon;
  const _CalendarChevron({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(border: Border.all(color: AppTheme.border)),
      child: Icon(icon, color: AppTheme.textMuted, size: 18),
    );
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
        Text(label,
            style: GoogleFonts.montserrat(
                fontSize: 10, color: AppTheme.textDim)),
      ],
    );
  }
}

// ─── Booking Form ─────────────────────────────────────────────
class _BookingForm extends StatelessWidget {
  final BookingState state;
  final VoidCallback onSubmit;

  const _BookingForm({required this.state, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BookingCubit>();
    final isRtl = context.locale.languageCode == 'ar';

    return Column(
      crossAxisAlignment:  CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.booking_form_title.tr(),
          textAlign: isRtl ? TextAlign.right : TextAlign.left,
          style: GoogleFonts.cormorantGaramond(
            fontSize: 38,
            fontWeight: FontWeight.w300,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          LocaleKeys.booking_form_subtitle.tr(),
          textAlign: isRtl ? TextAlign.right : TextAlign.left,
          style: GoogleFonts.montserrat(
              fontSize: 13, color: AppTheme.textMuted, height: 1.6),
        ),
        const SizedBox(height: 36),

        // Selected date display
        _FieldLabel(LocaleKeys.booking_date_label.tr(), isRtl),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            border: Border.all(color: AppTheme.border),
          ),
          child: Row(
            textDirection: isRtl ? ui.TextDirection.rtl : ui.TextDirection.ltr,
            children: [
              const Icon(Icons.calendar_today_outlined,
                  color: AppTheme.gold, size: 16),
              const SizedBox(width: 12),
              Text(
                state.selectedDay != null
                    ? DateFormat('EEEE, d MMMM yyyy', context.locale.languageCode).format(state.selectedDay!)
                    : LocaleKeys.booking_date_hint.tr(),
                style: GoogleFonts.montserrat(
                  fontSize: 13,
                  color: state.selectedDay != null
                      ? AppTheme.gold
                      : AppTheme.textDim,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Package
        _FieldLabel(LocaleKeys.form_package.tr(), isRtl),
        const SizedBox(height: 8),
        Directionality(
          textDirection: isRtl ? ui.TextDirection.rtl : ui.TextDirection.ltr,
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            value: state.selectedPackage.isEmpty ? null : state.selectedPackage,
            dropdownColor: AppTheme.surface,
            alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
            style: GoogleFonts.montserrat(
                fontSize: 13, color: AppTheme.textPrimary),
            decoration: const InputDecoration(),
            hint: Text(
              LocaleKeys.form_package_hint.tr(),
              style: GoogleFonts.montserrat(
                  fontSize: 13, color: AppTheme.textDim),
            ),
            items: [
              DropdownMenuItem(
                value: 'basic',
                alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
                child: Text(
                    '${LocaleKeys.nav_packages.tr()} 1 — ${LocaleKeys.pkg_1_name.tr()} (${LocaleKeys.pkg_1_duration.tr()}) - 2500 LE',
                    overflow: TextOverflow.ellipsis),
              ),
              DropdownMenuItem(
                value: 'half',
                alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
                child: Text(
                    '${LocaleKeys.nav_packages.tr()} 2 — ${LocaleKeys.pkg_2_name.tr()} (${LocaleKeys.pkg_2_duration.tr()}) - 3500 LE',
                    overflow: TextOverflow.ellipsis),
              ),
              DropdownMenuItem(
                value: 'full',
                alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
                child: Text(
                    '${LocaleKeys.nav_packages.tr()} 3 — ${LocaleKeys.pkg_3_name.tr()} (${LocaleKeys.pkg_3_duration.tr()}) - 4000 LE',
                    overflow: TextOverflow.ellipsis),
              ),
            ],
            onChanged: cubit.selectPackage,
          ),
        ),
        const SizedBox(height: 28),

        const SizedBox(height: 8),
        const SizedBox(height: 32),

        GoldButton(
          label: LocaleKeys.booking_confirm_btn.tr(),
          onTap: onSubmit,
          icon: Icons.calendar_today_outlined,
        ),
        const SizedBox(height: 16),
        Text(
          LocaleKeys.booking_contact_note.tr(),
          textAlign: isRtl ? TextAlign.right : TextAlign.left,
          style: GoogleFonts.montserrat(
              fontSize: 11, color: AppTheme.textDim, height: 1.6),
        ),
      ],
    ).animate().fadeIn(delay: 200.ms, duration: 700.ms).slideX(begin: isRtl ? -0.05 : 0.05, end: 0);
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  final bool isRtl;
  const _FieldLabel(this.text, this.isRtl);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
      child: Text(
        text.toUpperCase(),
        style: GoogleFonts.montserrat(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
          color: AppTheme.textMuted,
        ),
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
              color: isSelected ? AppTheme.gold : AppTheme.border),
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
