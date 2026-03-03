import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:photgraphy_system/admin/core/models/portfolio_category.dart';
import 'package:photgraphy_system/admin/core/theme/admin_theme.dart';
import 'package:photgraphy_system/admin/feature/portfolio/cubit/portfolio_cubit.dart';
import 'package:image_picker/image_picker.dart';
import 'shared_form_field.dart';

Future<void> showImagesDialog(
  BuildContext context, {
  required PortfolioCategory cat,
  required PortfolioCubit cubit,
}) async {
  await showDialog<void>(
    context: context,
    builder: (ctx) => _ImagesDialog(category: cat, cubit: cubit),
  );
}

class _ImagesDialog extends StatefulWidget {
  final PortfolioCategory category;
  final PortfolioCubit cubit;
  const _ImagesDialog({required this.category, required this.cubit});

  @override
  State<_ImagesDialog> createState() => _ImagesDialogState();
}

class _ImagesDialogState extends State<_ImagesDialog> {
  late PortfolioCategory _cat;
  final _urlCtrl = TextEditingController();
  final _captionCtrl = TextEditingController();
  final _captionArCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cat = widget.category;
  }

  @override
  void dispose() {
    _urlCtrl.dispose();
    _captionCtrl.dispose();
    _captionArCtrl.dispose();
    super.dispose();
  }

  void _addImage() {
    if (_urlCtrl.text.trim().isEmpty) return;
    final img = PortfolioImage(
      path: _urlCtrl.text.trim(),
      caption: _captionCtrl.text.trim(),
      captionAr: _captionArCtrl.text.trim(),
    );
    widget.cubit.addImage(_cat, img);
    setState(() {
      _urlCtrl.clear();
      _captionCtrl.clear();
      _captionArCtrl.clear();
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final xFile = await picker.pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      setState(() {
        _urlCtrl.text = xFile.path;
      });
    }
  }

  void _removeImage(PortfolioImage img) {
    widget.cubit.removeImage(_cat, img.id);
    setState(() => _cat.images.removeWhere((e) => e.id == img.id));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AdminTheme.surface,
      title: Text(
        tr('admin_portfolio_images_title',
            namedArgs: {'name': context.locale.languageCode == 'ar' && _cat.nameAr.isNotEmpty ? _cat.nameAr : _cat.name}),
        style: AdminTheme.headline(20),
      ),
      content: SizedBox(
        width: 620,
        height: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tr('admin_portfolio_add_image'),
                style: AdminTheme.label(size: 11)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: SharedFormField(
                    label: tr('admin_portfolio_image_url'),
                    hint: 'Path or https://...',
                    controller: _urlCtrl,
                    suffix: IconButton(
                      icon:  Icon(Icons.upload_file, color: AdminTheme.gold),
                      onPressed: _pickImage,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SharedFormField(
                    label: tr('admin_portfolio_caption_en'),
                    controller: _captionCtrl,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SharedFormField(
                    label: tr('admin_portfolio_caption_ar'),
                    controller: _captionArCtrl,
                  ),
                ),
                const SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    onPressed: _addImage,
                    child: Text(tr('admin_btn_add')),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _cat.images.isEmpty
                  ? Center(
                      child: Text(tr('admin_portfolio_no_images'),
                          style: AdminTheme.body(color: AdminTheme.textDim)),
                    )
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: _cat.images.length,
                      itemBuilder: (_, i) {
                        final img = _cat.images[i];
                        return Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: AdminTheme.surfaceAlt,
                                borderRadius: BorderRadius.circular(4),
                                image: img.path.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(img.path),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: img.path.isEmpty
                                  ? const Center(
                                      child: Icon(
                                          Icons.broken_image_rounded,
                                          color: AdminTheme.textDim))
                                  : null,
                            ),
                            Positioned(
                              top: 6,
                              right: 6,
                              child: GestureDetector(
                                onTap: () => _removeImage(img),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: AdminTheme.danger,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: const Icon(Icons.close_rounded,
                                      size: 12, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: Text(tr('admin_portfolio_done')),
        ),
      ],
    );
  }
}
