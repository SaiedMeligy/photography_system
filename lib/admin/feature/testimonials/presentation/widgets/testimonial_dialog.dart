import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:photgraphy_system/admin/core/models/testimonial_model.dart';
import 'package:photgraphy_system/admin/core/theme/admin_theme.dart';
import 'package:photgraphy_system/admin/feature/portfolio/presentation/widgets/shared_form_field.dart';

Future<TestimonialModel?> showTestimonialDialog(
  BuildContext context, {
  TestimonialModel? existing,
}) async {
  final nameCtrl = TextEditingController(text: existing?.clientName ?? '');
  final eventCtrl = TextEditingController(text: existing?.eventDescription ?? '');
  final textCtrl = TextEditingController(text: existing?.reviewText ?? '');
  double rating = existing?.rating ?? 5.0;

  final result = await showDialog<TestimonialModel>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setLocalState) => AlertDialog(
        backgroundColor: AdminTheme.surface,
        title: Text(
          existing == null
              ? tr('admin_testimonials_new_title')
              : tr('admin_testimonials_edit_title'),
          style: AdminTheme.headline(20),
        ),
        content: SizedBox(
          width: 480,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SharedFormField(
                  label: tr('admin_testimonials_client'), controller: nameCtrl),
              const SizedBox(height: 14),
              SharedFormField(
                label: tr('admin_testimonials_event'),
                hint: tr('admin_testimonials_event_hint'),
                controller: eventCtrl,
              ),
              const SizedBox(height: 14),
              SharedFormField(
                label: tr('admin_testimonials_text'),
                controller: textCtrl,
                maxLines: 4,
              ),
              const SizedBox(height: 14),
              _RatingPicker(
                rating: rating,
                onChanged: (v) => setLocalState(() => rating = v),
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
              final t = TestimonialModel(
                id: existing?.id,
                clientName: nameCtrl.text.trim(),
                eventDescription: eventCtrl.text.trim(),
                reviewText: textCtrl.text.trim(),
                rating: rating,
                isApproved: existing?.isApproved ?? true,
              );
              Navigator.pop(ctx, t);
            },
            child: Text(tr('admin_btn_save')),
          ),
        ],
      ),
    ),
  );

  nameCtrl.dispose();
  eventCtrl.dispose();
  textCtrl.dispose();
  return result;
}

class _RatingPicker extends StatelessWidget {
  final double rating;
  final ValueChanged<double> onChanged;

  const _RatingPicker({required this.rating, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(tr('admin_testimonials_rating').toUpperCase(),
            style: AdminTheme.label(size: 9)),
        const SizedBox(height: 8),
        Row(
          children: [
            ...List.generate(5, (i) {
              return GestureDetector(
                onTap: () => onChanged(i + 1.0),
                child: Icon(
                  i < rating
                      ? Icons.star_rounded
                      : Icons.star_border_rounded,
                  color: AdminTheme.gold,
                  size: 28,
                ),
              );
            }),
            const SizedBox(width: 10),
            Text(rating.toStringAsFixed(0),
                style: AdminTheme.body(
                    size: 14, color: AdminTheme.textPrimary)),
          ],
        ),
      ],
    );
  }
}
