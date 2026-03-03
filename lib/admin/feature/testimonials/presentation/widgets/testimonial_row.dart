import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:photgraphy_system/admin/core/models/testimonial_model.dart';
import 'package:photgraphy_system/admin/core/theme/admin_theme.dart';

class TestimonialRow extends StatelessWidget {
  final TestimonialModel testimonial;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggle;

  const TestimonialRow({
    super.key,
    required this.testimonial,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final t = testimonial;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AdminTheme.surface,
        border: Border.all(
          color: t.isApproved
              ? AdminTheme.border
              : AdminTheme.warning.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Avatar(name: t.clientName),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(t.clientName,
                        style: AdminTheme.body(
                            size: 14, color: AdminTheme.textPrimary)),
                    const SizedBox(width: 10),
                    Text(t.eventDescription,
                        style: AdminTheme.label(size: 9)),
                    const Spacer(),
                    _Stars(rating: t.rating),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  t.reviewText,
                  style: AdminTheme.body(size: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _ActionBtn(
                      icon: Icons.edit_rounded,
                      label: tr('admin_testimonials_edit'),
                      color: AdminTheme.info,
                      onTap: onEdit,
                    ),
                    const SizedBox(width: 8),
                    _ActionBtn(
                      icon: t.isApproved
                          ? Icons.visibility_off_rounded
                          : Icons.check_circle_rounded,
                      label: t.isApproved ? tr('admin_testimonials_hide') : tr('admin_testimonials_approve'),
                      color: t.isApproved
                          ? AdminTheme.warning
                          : AdminTheme.success,
                      onTap: onToggle,
                    ),
                    const SizedBox(width: 8),
                    _ActionBtn(
                      icon: Icons.delete_rounded,
                      label: tr('admin_testimonials_delete'),
                      color: AdminTheme.danger,
                      onTap: onDelete,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String name;
  const _Avatar({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AdminTheme.goldDim,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0] : '?',
          style: AdminTheme.label(size: 16, color: AdminTheme.gold),
        ),
      ),
    );
  }
}

class _Stars extends StatelessWidget {
  final double rating;
  const _Stars({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (i) {
        return Icon(
          i < rating.round()
              ? Icons.star_rounded
              : Icons.star_border_rounded,
          color: AdminTheme.gold,
          size: 14,
        );
      }),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          border: Border.all(color: color.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Row(
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 5),
            Text(label, style: AdminTheme.label(size: 9, color: color)),
          ],
        ),
      ),
    );
  }
}
