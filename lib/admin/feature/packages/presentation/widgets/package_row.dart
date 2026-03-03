import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:photgraphy_system/admin/core/models/package_model.dart';
import 'package:photgraphy_system/admin/core/theme/admin_theme.dart';

class PackageRow extends StatelessWidget {
  final PackageModel package;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PackageRow({
    super.key,
    required this.package,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final pkg = package;
    final isAr = context.locale.languageCode == 'ar';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AdminTheme.surface,
        border: Border.all(
          color: pkg.isPopular
              ? AdminTheme.gold.withValues(alpha: 0.4)
              : AdminTheme.border,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (pkg.isPopular) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AdminTheme.goldDim,
                    border: Border.all(
                        color: AdminTheme.gold.withValues(alpha: 0.4)),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Text(tr('admin_packages_popular'),
                      style: AdminTheme.label(
                          size: 9, color: AdminTheme.gold)),
                ),
                const SizedBox(width: 10),
              ],
              Text(
                isAr && pkg.tierAr.isNotEmpty ? pkg.tierAr : pkg.tier,
                style:
                    AdminTheme.label(size: 10, color: AdminTheme.gold),
              ),
              const Spacer(),
              Text(
                '${pkg.price.toStringAsFixed(0)} ${pkg.currency}',
                style: AdminTheme.headline(18)
                    .copyWith(color: AdminTheme.gold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isAr && pkg.nameAr.isNotEmpty ? pkg.nameAr : pkg.name,
                      style: AdminTheme.body(
                          size: 16, color: AdminTheme.textPrimary),
                    ),
                    Text(
                      isAr && pkg.durationAr.isNotEmpty
                          ? pkg.durationAr
                          : pkg.duration,
                      style: AdminTheme.label(size: 10),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 40),
              Expanded(
                flex: 2,
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: (isAr && pkg.featuresAr.isNotEmpty
                          ? pkg.featuresAr
                          : pkg.features)
                      .map((f) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AdminTheme.surfaceAlt,
                              borderRadius: BorderRadius.circular(3),
                              border: Border.all(color: AdminTheme.border),
                            ),
                            child: Text(f, style: AdminTheme.label(size: 9)),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_rounded, size: 14),
                label: Text(tr('admin_testimonials_edit')),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_rounded,
                    size: 14, color: AdminTheme.danger),
                label: Text(tr('admin_testimonials_delete'),
                    style: const TextStyle(color: AdminTheme.danger)),
                style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AdminTheme.danger)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
