import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:photgraphy_system/admin/core/models/booking_calendar_model.dart';
import 'package:photgraphy_system/admin/core/theme/admin_theme.dart';
import 'package:photgraphy_system/admin/feature/booking/cubit/booking_cubit.dart';
import 'package:photgraphy_system/admin/feature/booking/cubit/booking_state.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale; // Trigger rebuild on locale change
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        if (state.isLoading || state.calendar == null) {
          return const Center(
              child: CircularProgressIndicator(color: AdminTheme.gold));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tr('admin_booking_title'), style: AdminTheme.headline(22)),
              Text(tr('admin_booking_subtitle'),
                  style: AdminTheme.body(size: 13, color: AdminTheme.textDim)),
              const SizedBox(height: 32),
              
              LayoutBuilder(builder: (context, constraints) {
                if (constraints.maxWidth > 800) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: _CalendarCard(state: state)),
                      const SizedBox(width: 32),
                      Expanded(child: _SidePanel(state: state)),
                    ],
                  );
                }
                return Column(
                  children: [
                    _CalendarCard(state: state),
                    const SizedBox(height: 32),
                    _SidePanel(state: state),
                  ],
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

class _CalendarCard extends StatelessWidget {
  final BookingState state;
  const _CalendarCard({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AdminTheme.surface,
        border: Border.all(color: AdminTheme.border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: TableCalendar(
        firstDay: DateTime.now().subtract(const Duration(days: 365)),
        lastDay: DateTime.now().add(const Duration(days: 730)),
        focusedDay: DateTime.now(),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: AdminTheme.body(
              size: 16, color: AdminTheme.textPrimary, weight: FontWeight.w600),
          leftChevronIcon:
              const Icon(Icons.chevron_left, color: AdminTheme.gold),
          rightChevronIcon:
              const Icon(Icons.chevron_right, color: AdminTheme.gold),
        ),
        daysOfWeekStyle: const DaysOfWeekStyle(
          weekdayStyle: TextStyle(color: AdminTheme.textMuted, fontSize: 12),
          weekendStyle: TextStyle(color: AdminTheme.gold, fontSize: 12),
        ),
        calendarStyle: CalendarStyle(
          defaultTextStyle: const TextStyle(color: AdminTheme.textPrimary),
          outsideDaysVisible: false,
          todayDecoration: const BoxDecoration(
            color: AdminTheme.goldDim,
            shape: BoxShape.circle,
          ),
          todayTextStyle: const TextStyle(
              color: AdminTheme.gold, fontWeight: FontWeight.bold),
        ),
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            final status = state.calendar!.statusOf(day);
            if (status == BookingStatus.available) return null;

            return _StatusCell(day: day, status: status);
          },
        ),
        onDaySelected: (selectedDay, focusedDay) {
          context.read<BookingCubit>().updateDate(selectedDay);
        },
      ),
    );
  }
}

class _StatusCell extends StatelessWidget {
  final DateTime day;
  final BookingStatus status;
  const _StatusCell({required this.day, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = status == BookingStatus.booked
        ? AdminTheme.success
        : AdminTheme.danger;

    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color.withValues(alpha: 0.5)),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '${day.day}',
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _SidePanel extends StatelessWidget {
  final BookingState state;
  const _SidePanel({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BrushModeSelector(state: state),
        const SizedBox(height: 32),
        _BookedList(state: state),
      ],
    );
  }
}

class _BrushModeSelector extends StatelessWidget {
  final BookingState state;
  const _BrushModeSelector({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AdminTheme.surface,
        border: Border.all(color: AdminTheme.border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tr('admin_booking_mode').toUpperCase(),
              style: AdminTheme.label(size: 10)),
          const SizedBox(height: 16),
          _ModeRow(
            icon: Icons.check_circle_rounded,
            label: tr('admin_status_booked'),
            color: AdminTheme.success,
            isSelected: state.brushMode == BookingStatus.booked,
            onTap: () => context
                .read<BookingCubit>()
                .setBrushMode(BookingStatus.booked),
          ),
          const SizedBox(height: 10),
          _ModeRow(
            icon: Icons.block_flipped,
            label: tr('admin_status_blocked'),
            color: AdminTheme.danger,
            isSelected: state.brushMode == BookingStatus.blocked,
            onTap: () => context
                .read<BookingCubit>()
                .setBrushMode(BookingStatus.blocked),
          ),
          const SizedBox(height: 10),
          _ModeRow(
            icon: Icons.calendar_today_rounded,
            label: tr('admin_status_available'),
            color: AdminTheme.textMuted,
            isSelected: state.brushMode == BookingStatus.available,
            onTap: () => context
                .read<BookingCubit>()
                .setBrushMode(BookingStatus.available),
          ),
        ],
      ),
    );
  }
}

class _ModeRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeRow({
    required this.icon,
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.transparent,
          border: Border.all(
            color: isSelected ? color.withValues(alpha: 0.4) : AdminTheme.border,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: isSelected ? color : AdminTheme.textDim),
            const SizedBox(width: 12),
            Text(
              label,
              style: AdminTheme.body(
                  size: 13,
                  color: isSelected ? color : AdminTheme.textMuted,
                  weight: isSelected ? FontWeight.w600 : FontWeight.normal),
            ),
            const Spacer(),
            if (isSelected)
              Icon(Icons.brush_rounded, size: 14, color: color)
            else
              const SizedBox(width: 14),
          ],
        ),
      ),
    );
  }
}

class _BookedList extends StatelessWidget {
  final BookingState state;
  const _BookedList({required this.state});

  @override
  Widget build(BuildContext context) {
    final booked = state.calendar!.dates.entries
        .where((e) => e.value == BookingStatus.booked)
        .toList();
    booked.sort((a, b) => a.key.compareTo(b.key));

    return Container(
      constraints: const BoxConstraints(maxHeight: 400),
      decoration: BoxDecoration(
        color: AdminTheme.surface,
        border: Border.all(color: AdminTheme.border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(tr('admin_booking_booked_list').toUpperCase(),
                style: AdminTheme.label(size: 10)),
          ),
          const Divider(height: 1, color: AdminTheme.border),
          Expanded(
            child: booked.isEmpty
                ? Center(
                    child: Text(tr('admin_booking_no_bookings'),
                        style: AdminTheme.body(color: AdminTheme.textDim)),
                  )
                : ListView.separated(
                    itemCount: booked.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, color: AdminTheme.border),
                    itemBuilder: (_, i) {
                      final item = booked[i];
                      // item.key is 'yyyy-MM-dd'
                      final date = DateTime.tryParse(item.key) ?? DateTime.now();
                      final dateStr =
                          DateFormat('EEEE, d MMMM y').format(date);
                      return ListTile(
                        dense: true,
                        title: Text(dateStr, style: AdminTheme.body(size: 12)),
                        trailing: IconButton(
                          icon: const Icon(Icons.close,
                              size: 14, color: AdminTheme.danger),
                          onPressed: () =>
                              context.read<BookingCubit>().removeStatus(date),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
