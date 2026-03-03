import 'package:flutter/material.dart';
import '../../../../core/theme/admin_theme.dart';
import 'package:google_fonts/google_fonts.dart';

/// Collapsible section card used throughout admin screens.
class AdminSectionCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  final bool initiallyExpanded;

  const AdminSectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
    this.initiallyExpanded = true,
  });

  @override
  State<AdminSectionCard> createState() => _AdminSectionCardState();
}

class _AdminSectionCardState extends State<AdminSectionCard> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AdminTheme.surface,
        border: Border.all(color: AdminTheme.border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              child: Row(
                children: [
                  Icon(widget.icon, color: AdminTheme.gold, size: 18),
                  const SizedBox(width: 12),
                  Text(
                    widget.title,
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AdminTheme.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.keyboard_arrow_down_rounded,
                        color: AdminTheme.textDim, size: 20),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              decoration: const BoxDecoration(
                border:
                    Border(top: BorderSide(color: AdminTheme.border)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  ...widget.children,
                ],
              ),
            ),
            secondChild: const SizedBox(width: double.infinity),
            crossFadeState: _expanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }
}
