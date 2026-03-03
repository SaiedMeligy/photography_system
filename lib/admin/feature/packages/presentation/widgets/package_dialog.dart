import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:photgraphy_system/admin/core/models/package_model.dart';
import 'package:photgraphy_system/admin/core/theme/admin_theme.dart';
import 'package:photgraphy_system/admin/feature/portfolio/presentation/widgets/shared_form_field.dart';

Future<PackageModel?> showPackageDialog(
  BuildContext context, {
  PackageModel? existing,
}) async {
  final tierArCtrl = TextEditingController(text: existing?.tierAr ?? '');
  final tierCtrl = TextEditingController(text: existing?.tier ?? '');
  final nameArCtrl = TextEditingController(text: existing?.nameAr ?? '');
  final nameCtrl = TextEditingController(text: existing?.name ?? '');
  final durationArCtrl =
      TextEditingController(text: existing?.durationAr ?? '');
  final durationCtrl =
      TextEditingController(text: existing?.duration ?? '');
  final priceCtrl = TextEditingController(
      text: existing?.price.toStringAsFixed(0) ?? '');
  final featArCtrl = TextEditingController(
      text: (existing?.featuresAr ?? []).join('\n'));
  final featCtrl = TextEditingController(
      text: (existing?.features ?? []).join('\n'));
  bool isPopular = existing?.isPopular ?? false;

  final result = await showDialog<PackageModel>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setLocalState) => AlertDialog(
        backgroundColor: AdminTheme.surface,
        title: Text(
          existing == null
              ? tr('admin_packages_new_title')
              : tr('admin_packages_edit_title'),
          style: AdminTheme.headline(20),
        ),
        content: SizedBox(
          width: 620,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Row2(
                  left: SharedFormField(
                      label: tr('admin_packages_tier_ar'),
                      controller: tierArCtrl),
                  right: SharedFormField(
                      label: tr('admin_packages_tier_en'),
                      controller: tierCtrl),
                ),
                const SizedBox(height: 14),
                _Row2(
                  left: SharedFormField(
                      label: tr('admin_packages_name_ar'),
                      controller: nameArCtrl),
                  right: SharedFormField(
                      label: tr('admin_packages_name_en'),
                      controller: nameCtrl),
                ),
                const SizedBox(height: 14),
                _Row3(
                  c1: SharedFormField(
                      label: tr('admin_packages_duration_ar'),
                      controller: durationArCtrl),
                  c2: SharedFormField(
                      label: tr('admin_packages_duration_en'),
                      controller: durationCtrl),
                  c3: SharedFormField(
                      label: tr('admin_packages_price'),
                      controller: priceCtrl,
                      keyboardType: TextInputType.number),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Switch(
                      value: isPopular,
                      onChanged: (v) =>
                          setLocalState(() => isPopular = v),
                    ),
                    const SizedBox(width: 8),
                    Text(tr('admin_packages_mark_popular'),
                        style: AdminTheme.body()),
                  ],
                ),
                const SizedBox(height: 14),
                _Row2(
                  left: SharedFormField(
                    label: tr('admin_packages_features_ar'),
                    controller: featArCtrl,
                    maxLines: 5,
                  ),
                  right: SharedFormField(
                    label: tr('admin_packages_features_en'),
                    controller: featCtrl,
                    maxLines: 5,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(tr('admin_btn_cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              final pkg = PackageModel(
                id: existing?.id,
                tier: tierCtrl.text.trim(),
                tierAr: tierArCtrl.text.trim(),
                name: nameCtrl.text.trim(),
                nameAr: nameArCtrl.text.trim(),
                duration: durationCtrl.text.trim(),
                durationAr: durationArCtrl.text.trim(),
                price:
                    double.tryParse(priceCtrl.text.trim()) ?? 0,
                features: featCtrl.text
                    .split('\n')
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toList(),
                featuresAr: featArCtrl.text
                    .split('\n')
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toList(),
                isPopular: isPopular,
                sortOrder: existing?.sortOrder ?? 0,
              );
              Navigator.pop(ctx, pkg);
            },
            child: Text(tr('admin_btn_save')),
          ),
        ],
      ),
    ),
  );

  for (final c in [
    tierArCtrl, tierCtrl, nameArCtrl, nameCtrl, durationArCtrl,
    durationCtrl, priceCtrl, featArCtrl, featCtrl,
  ]) {
    c.dispose();
  }
  return result;
}

class _Row2 extends StatelessWidget {
  final Widget left, right;
  const _Row2({required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: left),
      const SizedBox(width: 12),
      Expanded(child: right),
    ]);
  }
}

class _Row3 extends StatelessWidget {
  final Widget c1, c2, c3;
  const _Row3({required this.c1, required this.c2, required this.c3});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: c1),
      const SizedBox(width: 12),
      Expanded(child: c2),
      const SizedBox(width: 12),
      Expanded(child: c3),
    ]);
  }
}
