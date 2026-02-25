import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/translations/locale_keys.g.dart';

class AppShell extends StatefulWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  bool _scrolled = false;
  bool _menuOpen = false;

  // Nav items use translation keys
  static const _navItems = [
    _NavItem(labelKey: LocaleKeys.nav_home,         path: '/'),
    _NavItem(labelKey: LocaleKeys.nav_portfolio,    path: '/portfolio'),
    _NavItem(labelKey: LocaleKeys.nav_packages,     path: '/packages'),
    _NavItem(labelKey: LocaleKeys.nav_book,         path: '/booking'),
    _NavItem(labelKey: LocaleKeys.nav_testimonials, path: '/testimonials'),
  ];

  void _onScroll(double offset) {
    final scrolled = offset > 40;
    if (scrolled != _scrolled) setState(() => _scrolled = scrolled);
  }

  void _toggleTheme() {
    themeNotifier.value = themeNotifier.value == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
  }

  void _toggleLang() {
    final isAr = context.locale.languageCode == 'ar';
    context.setLocale(isAr ? const Locale('en') : const Locale('ar'));
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    final location = GoRouterState.of(context).uri.toString();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navBg = isDark ? AppTheme.darkBg : AppTheme.lightBg;
    final textCol = isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary;
    final textMutedCol = isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted;
    final borderCol = isDark ? AppTheme.darkBorder : AppTheme.lightBorder;
    final isAr = context.locale.languageCode == 'ar';

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
      body: Stack(
        children: [
          // Main content
          NotificationListener<ScrollNotification>(
            onNotification: (n) {
              if (n is ScrollUpdateNotification) {
                _onScroll(n.metrics.pixels);
              }
              return false;
            },
            child: widget.child,
          ),

          // Navbar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 24 : 60,
                vertical: _scrolled ? 14 : 24,
              ),
              decoration: BoxDecoration(
                color: _scrolled
                    ? navBg.withOpacity(0.96)
                    : Colors.transparent,
                border: _scrolled
                    ? Border(
                        bottom: BorderSide(color: borderCol, width: 1),
                      )
                    : null,
                boxShadow: _scrolled
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.4 : 0.12),
                          blurRadius: 20,
                        )
                      ]
                    : [],
              ),
              child: Row(
                children: [
                  // Logo
                  GestureDetector(
                    onTap: () => context.go('/'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'iBrahiim',
                          style: GoogleFonts.dancingScript(
                            fontSize: 32,
                            color: AppTheme.gold,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'PHOTOGRAPHY',
                          style: GoogleFonts.montserrat(
                            fontSize: 9,
                            letterSpacing: 0.35,
                            color: textMutedCol,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),

                  if (!isMobile) ...[
                    // Desktop links
                    ...(_navItems.map((item) {
                      final isActive = location == item.path;
                      return _NavLink(
                        item: item,
                        isActive: isActive,
                        onTap: () => context.go(item.path),
                      );
                    })),
                    const SizedBox(width: 16),

                    // 🌐 Language Toggle
                    _LangToggle(isAr: isAr, onToggle: _toggleLang),
                    const SizedBox(width: 8),

                    // 🌙/☀️ Theme Toggle
                    _ThemeToggle(isDark: isDark, onToggle: _toggleTheme),

                    const SizedBox(width: 24),
                    _BookNowBtn(onTap: () => context.go('/booking')),
                  ] else ...[
                    // 🌐 Language Toggle (mobile)
                    _LangToggle(isAr: isAr, onToggle: _toggleLang),
                    const SizedBox(width: 4),
                    // 🌙/☀️ Theme Toggle (mobile)
                    _ThemeToggle(isDark: isDark, onToggle: _toggleTheme),
                    // Hamburger
                    IconButton(
                      icon: Icon(
                        _menuOpen ? Icons.close : Icons.menu,
                        color: textCol,
                        size: 26,
                      ),
                      onPressed: () => setState(() => _menuOpen = !_menuOpen),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Mobile Menu
          Positioned.fill(
            child: Visibility(
              visible: _menuOpen,
              child: IgnorePointer(
                ignoring: !_menuOpen,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _menuOpen ? 1.0 : 0.0,
                  child: _MobileMenu(
                    navItems: _navItems,
                    currentPath: location,
                    onItemTap: (path) {
                      setState(() => _menuOpen = false);
                      context.go(path);
                    },
                    onClose: () => setState(() => _menuOpen = false),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Language Toggle ──────────────────────────────────────────
class _LangToggle extends StatefulWidget {
  final bool isAr;
  final VoidCallback onToggle;
  const _LangToggle({required this.isAr, required this.onToggle});

  @override
  State<_LangToggle> createState() => _LangToggleState();
}

class _LangToggleState extends State<_LangToggle> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onToggle,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _hover ? AppTheme.goldDim : Colors.transparent,
            border: Border.all(
              color: _hover ? AppTheme.gold : AppTheme.gold.withOpacity(0.4),
            ),
          ),
          child: Text(
            widget.isAr ? 'EN' : 'AR',
            style: GoogleFonts.montserrat(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.1,
              color: AppTheme.gold,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Theme Toggle Button ───────────────────────────────────────
class _ThemeToggle extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggle;
  const _ThemeToggle({required this.isDark, required this.onToggle});

  @override
  State<_ThemeToggle> createState() => _ThemeToggleState();
}

class _ThemeToggleState extends State<_ThemeToggle> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onToggle,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: _hover ? AppTheme.goldDim : Colors.transparent,
            border: Border.all(
              color: _hover ? AppTheme.gold : AppTheme.gold.withOpacity(0.4),
            ),
          ),
          child: Icon(
            widget.isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            color: AppTheme.gold,
            size: 18,
          ),
        ),
      ),
    );
  }
}

// ─── Nav Link ─────────────────────────────────────────────────
class _NavLink extends StatefulWidget {
  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;
  const _NavLink({required this.item, required this.isActive, required this.onTap});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textCol = isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.item.labelKey.tr().toUpperCase(),
                style: GoogleFonts.montserrat(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                  color: (widget.isActive || _hover)
                      ? AppTheme.gold
                      : textCol,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 1,
                width: (widget.isActive || _hover) ? 24 : 0,
                color: AppTheme.gold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Book Now Button ─────────────────────────────────────────
class _BookNowBtn extends StatefulWidget {
  final VoidCallback onTap;
  const _BookNowBtn({required this.onTap});

  @override
  State<_BookNowBtn> createState() => _BookNowBtnState();
}

class _BookNowBtnState extends State<_BookNowBtn> {
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: _hover ? AppTheme.goldLight : AppTheme.gold,
            border: Border.all(color: AppTheme.gold),
          ),
          child: Text(
            LocaleKeys.nav_book.tr().toUpperCase(),
            style: GoogleFonts.montserrat(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.25,
              color: AppTheme.darkBg,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Mobile Menu ─────────────────────────────────────────────
class _MobileMenu extends StatelessWidget {
  final List<_NavItem> navItems;
  final String currentPath;
  final void Function(String) onItemTap;
  final VoidCallback onClose;

  const _MobileMenu({
    required this.navItems,
    required this.currentPath,
    required this.onItemTap,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgCol = isDark ? AppTheme.darkBg : AppTheme.lightBg;
    final textCol = isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted;

    return SizedBox.expand(
      child: Container(
        color: bgCol,
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: navItems.map((item) {
                  final isActive = currentPath == item.path;
                  return GestureDetector(
                    onTap: () => onItemTap(item.path),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        item.labelKey.tr(),
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 52,
                          fontWeight: FontWeight.w300,
                          color: isActive ? AppTheme.gold : textCol,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Positioned(
              top: 30,
              right: 24,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                  size: 28,
                ),
                onPressed: onClose,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Data class ───────────────────────────────────────────────
class _NavItem {
  final String labelKey;
  final String path;
  const _NavItem({required this.labelKey, required this.path});
}
