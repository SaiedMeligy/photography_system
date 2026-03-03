import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photgraphy_system/admin/core/theme/admin_theme.dart';
import 'package:photgraphy_system/admin/feature/shell/cubit/shell_cubit.dart';
import 'package:photgraphy_system/admin/feature/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:photgraphy_system/admin/feature/settings/presentation/screens/settings_screen.dart';
import 'package:photgraphy_system/admin/feature/portfolio/presentation/screens/portfolio_screen.dart';
import 'package:photgraphy_system/admin/feature/packages/presentation/screens/packages_screen.dart';
import 'package:photgraphy_system/admin/feature/testimonials/presentation/screens/testimonials_screen.dart';
import 'package:photgraphy_system/admin/feature/booking/presentation/screens/booking_screen.dart';

class AdminShell extends StatelessWidget {
  const AdminShell({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale; // Trigger rebuild on locale change
    return BlocBuilder<ShellCubit, int>(
      builder: (context, activeIndex) {
        final screens = [
          const DashboardScreen(),
          const SettingsScreen(),
          const PortfolioScreen(),
          const PackagesScreen(),
          const TestimonialsScreen(),
          const BookingScreen(),
        ];

        return Scaffold(
          backgroundColor: AdminTheme.bg,
          body: Row(
            children: [
              _Sidebar(
                activeIndex: activeIndex,
                onNavTap: (i) => context.read<ShellCubit>().setIndex(i),
              ),
              Expanded(
                child: Column(
                  children: [
                    _TopBar(activeIndex: activeIndex),
                    Expanded(
                      child: IndexedStack(
                        index: activeIndex,
                        children: screens,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Sidebar extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onNavTap;

  const _Sidebar({required this.activeIndex, required this.onNavTap});

  @override
  Widget build(BuildContext context) {
    final navItems = [
      _NavItem(Icons.dashboard_outlined, tr('admin_nav_dashboard')),
      _NavItem(Icons.settings_outlined, tr('admin_nav_settings')),
      _NavItem(Icons.photo_library_outlined, tr('admin_nav_portfolio')),
      _NavItem(Icons.inventory_2_outlined, tr('admin_nav_packages')),
      _NavItem(Icons.star_outline_rounded, tr('admin_nav_testimonials')),
      _NavItem(Icons.calendar_month_outlined, tr('admin_nav_booking')),
    ];

    return Container(
      width: 250,
      decoration: const BoxDecoration(
        color: AdminTheme.surface,
        border: Border(right: BorderSide(color: AdminTheme.border)),
      ),
      child: Column(
        children: [
          _SidebarHeader(),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: navItems.length,
              itemBuilder: (context, i) {
                final item = navItems[i];
                return _SidebarItem(
                  icon: item.icon,
                  label: item.label,
                  isActive: i == activeIndex,
                  onTap: () => onNavTap(i),
                );
              },
            ),
          ),
          _SidebarFooter(),
        ],
      ),
    );
  }
}

class _SidebarHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'IBRAHIIM',
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: 4,
              color: AdminTheme.gold,
            ),
          ),
          Text(
            tr('admin_panel'),
            style: AdminTheme.label(size: 8, color: AdminTheme.textDim),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.isActive;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: active
                ? AdminTheme.gold.withValues(alpha: 0.1)
                : (_hovered
                    ? AdminTheme.border.withValues(alpha: 0.3)
                    : Colors.transparent),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 20,
                color: active ? AdminTheme.gold : AdminTheme.textMuted,
              ),
              const SizedBox(width: 16),
              Text(
                widget.label,
                style: AdminTheme.body(
                  size: 13,
                  color: active ? AdminTheme.textPrimary : AdminTheme.textMuted,
                  weight: active ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              if (active) ...[
                const Spacer(),
                Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: AdminTheme.gold,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SidebarFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AdminTheme.border)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AdminTheme.goldDim,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.person, size: 16, color: AdminTheme.gold),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Admin',
                        style: AdminTheme.body(
                            size: 12, weight: FontWeight.w600)),
                    Text(tr('admin_manager'),
                        style: AdminTheme.label(size: 8)),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  final current = context.locale.languageCode;
                  context.setLocale(
                      current == 'ar' ? const Locale('en') : const Locale('ar'));
                },
                icon: const Icon(Icons.language, size: 16, color: AdminTheme.textDim),
                tooltip: tr('lang_toggle'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final int activeIndex;
  const _TopBar({required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    final titles = [
      tr('admin_nav_dashboard'),
      tr('admin_nav_settings'),
      tr('admin_nav_portfolio'),
      tr('admin_nav_packages'),
      tr('admin_nav_testimonials'),
      tr('admin_nav_booking'),
    ];

    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: const BoxDecoration(
        color: AdminTheme.surface,
        border: Border(bottom: BorderSide(color: AdminTheme.border)),
      ),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titles[activeIndex],
                style: AdminTheme.headline(24),
              ),
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AdminTheme.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    tr('admin_online'),
                    style: AdminTheme.label(size: 9, color: AdminTheme.success),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          const _HeaderAction(icon: Icons.notifications_none_rounded),
          const SizedBox(width: 16),
          const _HeaderAction(icon: Icons.logout_rounded, color: AdminTheme.danger),
        ],
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  final IconData icon;
  final Color color;
  const _HeaderAction(
      {required this.icon, this.color = AdminTheme.textDim});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: AdminTheme.border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(icon, size: 20, color: color),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem(this.icon, this.label);
}
