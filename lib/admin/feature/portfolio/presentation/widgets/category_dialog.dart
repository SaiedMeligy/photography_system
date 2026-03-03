import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:photgraphy_system/admin/core/models/portfolio_category.dart';
import 'package:photgraphy_system/admin/core/theme/admin_theme.dart';
import 'package:image_picker/image_picker.dart';
import 'shared_form_field.dart';

/// Shows add/edit category dialog. Returns the new/updated category or null.
Future<PortfolioCategory?> showCategoryDialog(
  BuildContext context, {
  PortfolioCategory? existing,
}) async {
  final nameCtrl = TextEditingController(text: existing?.name ?? '');
  final nameArCtrl = TextEditingController(text: existing?.nameAr ?? '');
  final coverCtrl =
      TextEditingController(text: existing?.coverImage ?? '');

  final result = await showDialog<PortfolioCategory>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AdminTheme.surface,
      title: Text(
        existing == null
            ? tr('admin_portfolio_new_title')
            : tr('admin_portfolio_edit_title'),
        style: AdminTheme.headline(20),
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SharedFormField(
                label: tr('admin_portfolio_name_ar'),
                controller: nameArCtrl),
            const SizedBox(height: 16),
            SharedFormField(
                label: tr('admin_portfolio_name_en'),
                controller: nameCtrl),
            const SizedBox(height: 16),
            SharedFormField(
              label: tr('admin_portfolio_cover'),
              hint: 'Path or https://...',
              controller: coverCtrl,
              suffix: IconButton(
                icon: const Icon(Icons.upload_file, color: AdminTheme.gold),
                onPressed: () async {
                  final picker = ImagePicker();
                  final xFile = await picker.pickImage(source: ImageSource.gallery);
                  if (xFile != null) {
                    coverCtrl.text = xFile.path;
                  }
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(tr('admin_btn_cancel')),
        ),
        ElevatedButton(
          onPressed: () {
            final cat = existing != null
                ? (existing
                  ..name = nameCtrl.text.trim()
                  ..nameAr = nameArCtrl.text.trim()
                  ..coverImage = coverCtrl.text.trim())
                : PortfolioCategory(
                    name: nameCtrl.text.trim(),
                    nameAr: nameArCtrl.text.trim(),
                    coverImage: coverCtrl.text.trim(),
                  );
            Navigator.pop(ctx, cat);
          },
          child: Text(tr('admin_btn_save')),
        ),
      ],
    ),
  );

  nameCtrl.dispose();
  nameArCtrl.dispose();
  coverCtrl.dispose();
  return result;
}

/// Shows a generic confirmation dialog. Returns true if confirmed.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AdminTheme.surface,
      title: Text(title, style: AdminTheme.headline(20)),
      content: Text(message, style: AdminTheme.body()),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(tr('admin_btn_cancel')),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: AdminTheme.danger),
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(tr('admin_btn_delete')),
        ),
      ],
    ),
  );
  return result ?? false;
}
