import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/models/portfolio_category.dart';
import '../../../../core/theme/admin_theme.dart';

class CategoryCard extends StatefulWidget {
  final PortfolioCategory category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onManageImages;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onEdit,
    required this.onDelete,
    required this.onManageImages,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final cat = widget.category;
    final isAr = context.locale.languageCode == 'ar';
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: AdminTheme.surface,
          border: Border.all(
            color: _hovered
                ? AdminTheme.gold.withValues(alpha: 0.4)
                : AdminTheme.border,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover image
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AdminTheme.surfaceAlt,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4)),
                      image: cat.coverImage.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(cat.coverImage),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: cat.coverImage.isEmpty
                        ? Center(
                            child: Icon(Icons.photo_camera_rounded,
                                color: AdminTheme.textDim, size: 32),
                          )
                        : null,
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AdminTheme.bg.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text(
                        tr('admin_portfolio_count',
                            namedArgs: {'count': cat.images.length.toString()}),
                        style: AdminTheme.label(size: 9),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Info + actions
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isAr && cat.nameAr.isNotEmpty ? cat.nameAr : cat.name,
                    style: AdminTheme.body(
                        size: 14, color: AdminTheme.textPrimary),
                  ),
                  if (cat.name.isNotEmpty && cat.nameAr.isNotEmpty)
                    Text(cat.name, style: AdminTheme.label(size: 9)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _CardBtn(
                        icon: Icons.image_rounded,
                        label: tr('admin_portfolio_images'),
                        color: AdminTheme.info,
                        onTap: widget.onManageImages,
                      ),
                      const SizedBox(width: 6),
                      _CardBtn(
                        icon: Icons.edit_rounded,
                        label: tr('admin_portfolio_edit'),
                        color: AdminTheme.warning,
                        onTap: widget.onEdit,
                      ),
                      const SizedBox(width: 6),
                      _CardBtn(
                        icon: Icons.delete_rounded,
                        label: tr('admin_portfolio_delete'),
                        color: AdminTheme.danger,
                        onTap: widget.onDelete,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _CardBtn({
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
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Row(
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
            Text(label, style: AdminTheme.label(size: 9, color: color)),
          ],
        ),
      ),
    );
  }
}
