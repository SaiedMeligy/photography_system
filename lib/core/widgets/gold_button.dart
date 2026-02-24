import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class GoldButton extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;
  final bool outline;
  final IconData? icon;
  const GoldButton({
    super.key,
    required this.label,
    this.onTap,
    this.outline = false,
    this.icon,
  });

  @override
  State<GoldButton> createState() => _GoldButtonState();
}

class _GoldButtonState extends State<GoldButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
          decoration: BoxDecoration(
            color: widget.outline
                ? (_hovering ? AppTheme.gold : Colors.transparent)
                : (_hovering ? AppTheme.goldLight : AppTheme.gold),
            border: Border.all(
              color: AppTheme.gold,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  size: 14,
                  color: widget.outline && !_hovering
                      ? AppTheme.gold
                      : AppTheme.bg,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                widget.label.toUpperCase(),
                style: GoogleFonts.montserrat(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                  color: widget.outline && !_hovering
                      ? AppTheme.gold
                      : AppTheme.bg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
