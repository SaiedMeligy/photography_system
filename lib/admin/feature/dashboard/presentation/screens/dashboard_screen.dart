import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photgraphy_system/admin/core/services/admin_data_service.dart';
import 'package:photgraphy_system/admin/core/theme/admin_theme.dart';
import 'package:photgraphy_system/admin/feature/dashboard/cubit/dashboard_cubit.dart';
import 'package:photgraphy_system/admin/feature/dashboard/cubit/dashboard_state.dart';
import 'package:photgraphy_system/admin/feature/shell/cubit/shell_cubit.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale; // Trigger rebuild on locale change
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
              child: CircularProgressIndicator(color: AdminTheme.gold));
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _WelcomeHeader(state: state),
              const SizedBox(height: 36),
              _StatsGrid(state: state),
              const SizedBox(height: 36),
              _QuickActionsSection(),
              const SizedBox(height: 36),
              _RecentReviewsSection(),
            ],
          ),
        );
      },
    );
  }
}

// ─── Welcome Header ───────────────────────────────────────────
class _WelcomeHeader extends StatelessWidget {
  final DashboardState state;
  const _WelcomeHeader({required this.state});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tr('admin_welcome', namedArgs: {'name': state.photographerName}),
                style: AdminTheme.headline(32, weight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(tr('admin_welcome_sub'), style: AdminTheme.body(size: 16)),
            ],
          ),
        ),
        IconButton(
          onPressed: () => context.read<DashboardCubit>().load(),
          icon: const Icon(Icons.refresh_rounded,
              color: AdminTheme.textMuted, size: 20),
          tooltip: tr('admin_refresh'),
        ),
      ],
    );
  }
}

// ─── Stats Grid ───────────────────────────────────────────────
class _StatsGrid extends StatelessWidget {
  final DashboardState state;
  const _StatsGrid({required this.state});

  @override
  Widget build(BuildContext context) {
    final items = [
      _StatData(
        icon: Icons.inventory_2_rounded,
        label: tr('admin_stat_packages'),
        value: state.totalPackages.toString(),
        color: AdminTheme.warning,
      ),
      _StatData(
        icon: Icons.photo_library_rounded,
        label: tr('admin_stat_categories'),
        value: state.totalCategories.toString(),
        color: AdminTheme.info,
      ),
      _StatData(
        icon: Icons.star_rounded,
        label: tr('admin_stat_reviews'),
        value: state.totalTestimonials.toString(),
        color: AdminTheme.gold,
      ),
      _StatData(
        icon: Icons.calendar_month_rounded,
        label: tr('admin_stat_booked'),
        value: state.bookedDates.toString(),
        color: AdminTheme.success,
      ),
    ];

    return LayoutBuilder(builder: (context, constraints) {
      final columns = constraints.maxWidth > 600 ? 4 : 2;
      return GridView.count(
        crossAxisCount: columns,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: columns == 4 ? 2.0 : 1.3,
        children: items.map((e) => _StatCard(data: e)).toList(),
      );
    });
  }
}

class _StatCard extends StatelessWidget {
  final _StatData data;
  const _StatCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AdminTheme.surface,
        border: Border.all(color: AdminTheme.border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: data.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(data.icon, color: data.color, size: 20),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                data.value,
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 34,
                  color: AdminTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(data.label, style: AdminTheme.label(size: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Quick Actions ────────────────────────────────────────────
class _QuickActionsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final shell = context.read<ShellCubit>();
    final actions = [
      _ActionData(
        icon: Icons.photo_library_rounded,
        label: tr('admin_action_add_category'),
        color: AdminTheme.info,
        onTap: () => shell.setIndex(2),
      ),
      _ActionData(
        icon: Icons.inventory_2_rounded,
        label: tr('admin_action_edit_packages'),
        color: AdminTheme.warning,
        onTap: () => shell.setIndex(3),
      ),
      _ActionData(
        icon: Icons.calendar_today_rounded,
        label: tr('admin_action_manage_bookings'),
        color: AdminTheme.success,
        onTap: () => shell.setIndex(5),
      ),
      _ActionData(
        icon: Icons.star_rounded,
        label: tr('admin_action_review'),
        color: AdminTheme.gold,
        onTap: () => shell.setIndex(4),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(tr('admin_quick_actions'), style: AdminTheme.label(size: 16)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: actions.map((a) => _QuickActionChip(data: a)).toList(),
        ),
      ],
    );
  }
}

class _QuickActionChip extends StatefulWidget {
  final _ActionData data;
  const _QuickActionChip({required this.data});

  @override
  State<_QuickActionChip> createState() => _QuickActionChipState();
}

class _QuickActionChipState extends State<_QuickActionChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.data.onTap,
        child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: _hovered
              ? widget.data.color.withValues(alpha: 0.12)
              : AdminTheme.surfaceAlt,
          border: Border.all(
            color: _hovered
                ? widget.data.color.withValues(alpha: 0.5)
                : AdminTheme.border,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(widget.data.icon, color: widget.data.color, size: 20),
            const SizedBox(width: 10),
            Text(widget.data.label, style: AdminTheme.body(size: 14)),
          ],
        ),
      ),
      ),
    );
  }
}

// ─── Recent Reviews ───────────────────────────────────────────
class _RecentReviewsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final list = AdminDataService.getTestimonials().take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(tr('admin_recent_reviews'), style: AdminTheme.label(size: 16)),
        const SizedBox(height: 16),
        if (list.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AdminTheme.surface,
              border: Border.all(color: AdminTheme.border),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(tr('admin_no_reviews'),
                  style: AdminTheme.body(color: AdminTheme.textDim)),
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: AdminTheme.surface,
              border: Border.all(color: AdminTheme.border),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              children: list.asMap().entries.map((entry) {
                final t = entry.value;
                final isLast = entry.key == list.length - 1;
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: isLast
                        ? null
                        : const Border(
                            bottom: BorderSide(color: AdminTheme.border)),
                  ),
                  child: Row(
                    children: [
                      _Avatar(name: t.clientName),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t.clientName,
                                style: AdminTheme.body(
                                    size: 16,
                                    weight: FontWeight.w600,
                                    color: AdminTheme.textPrimary)),
                            const SizedBox(height: 4),
                            Text(t.eventDescription,
                                style: AdminTheme.label(size: 12)),
                            const SizedBox(height: 8),
                            Text(
                              t.reviewText,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AdminTheme.body(size: 14),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Row(
                        children: List.generate(5, (i) {
                          return Icon(
                            i < t.rating.round()
                                ? Icons.star
                                : Icons.star_border,
                            color: AdminTheme.gold,
                            size: 14,
                          );
                        }),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  final String name;
  const _Avatar({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AdminTheme.goldDim,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0] : '?',
          style: AdminTheme.label(color: AdminTheme.gold),
        ),
      ),
    );
  }
}

// ─── Data Classes ─────────────────────────────────────────────
class _StatData {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatData({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
}

class _ActionData {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionData({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}
