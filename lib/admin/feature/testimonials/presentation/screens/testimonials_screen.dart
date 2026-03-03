import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photgraphy_system/admin/core/models/testimonial_model.dart';
import 'package:photgraphy_system/admin/core/theme/admin_theme.dart';
import 'package:photgraphy_system/admin/feature/testimonials/cubit/testimonials_cubit.dart';
import 'package:photgraphy_system/admin/feature/testimonials/cubit/testimonials_state.dart';
import '../widgets/testimonial_row.dart';
import '../widgets/testimonial_dialog.dart';
import 'package:photgraphy_system/admin/feature/portfolio/presentation/widgets/category_dialog.dart'; // For showConfirmDialog

class TestimonialsScreen extends StatelessWidget {
  const TestimonialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale; // Trigger rebuild on locale change
    return BlocBuilder<TestimonialsCubit, TestimonialsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
              child: CircularProgressIndicator(color: AdminTheme.gold));
        }

        final pending = state.pending;
        final approved = state.approved;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(total: state.testimonials.length, pendingCount: pending.length),
              const SizedBox(height: 24),

              if (pending.isNotEmpty) ...[
                _SectionLabel(label: tr('admin_testimonials_pending'), color: AdminTheme.warning),
                const SizedBox(height: 12),
                ...pending.map((t) => TestimonialRow(
                      testimonial: t,
                      onEdit: () => _showDialog(context, existing: t),
                      onDelete: () => _confirmDelete(context, t),
                      onToggle: () => context.read<TestimonialsCubit>().toggleApproval(t),
                    )),
                const SizedBox(height: 24),
              ],

              _SectionLabel(label: tr('admin_testimonials_approved'), color: AdminTheme.success),
              const SizedBox(height: 12),

              if (approved.isEmpty && pending.isEmpty)
                _EmptyState(onAdd: () => _showDialog(context))
              else
                ...approved.map((t) => TestimonialRow(
                      testimonial: t,
                      onEdit: () => _showDialog(context, existing: t),
                      onDelete: () => _confirmDelete(context, t),
                      onToggle: () => context.read<TestimonialsCubit>().toggleApproval(t),
                    )),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showDialog(BuildContext context, {TestimonialModel? existing}) async {
    final result = await showTestimonialDialog(context, existing: existing);
    if (result != null && context.mounted) {
      context.read<TestimonialsCubit>().save(result);
    }
  }

  Future<void> _confirmDelete(BuildContext context, TestimonialModel t) async {
    final confirmed = await showConfirmDialog(
      context,
      title: tr('admin_delete_title'),
      message: tr('admin_delete_confirm'),
    );
    if (confirmed && context.mounted) {
      context.read<TestimonialsCubit>().delete(t.id);
    }
  }
}

class _Header extends StatelessWidget {
  final int total;
  final int pendingCount;
  const _Header({required this.total, required this.pendingCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '${tr("admin_testimonials_title")} ($total)',
          style: AdminTheme.headline(22),
        ),
        if (pendingCount > 0) ...[
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AdminTheme.warningDim,
              borderRadius: BorderRadius.circular(2),
            ),
            child: Text(
              tr('admin_testimonials_pending_badge', namedArgs: {'count': pendingCount.toString()}),
              style: AdminTheme.label(size: 9, color: AdminTheme.warning),
            ),
          ),
        ],
        const Spacer(),
        ElevatedButton.icon(
          onPressed: () => _showTestimonialDialogInline(context),
          icon: const Icon(Icons.add_rounded, size: 18),
          label: Text(tr('admin_testimonials_add')),
        ),
      ],
    );
  }

  Future<void> _showTestimonialDialogInline(BuildContext context) async {
    final result = await showTestimonialDialog(context);
    if (result != null && context.mounted) {
      context.read<TestimonialsCubit>().save(result);
    }
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final Color color;
  const _SectionLabel({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 14,
          color: color,
          margin: const EdgeInsets.only(right: 10),
        ),
        Text(label, style: AdminTheme.label(size: 11, color: color)),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60),
      alignment: Alignment.center,
      child: Column(
        children: [
          const Icon(Icons.star_rounded, size: 48, color: AdminTheme.textDim),
          const SizedBox(height: 16),
          Text(tr('admin_testimonials_empty'),
              style: AdminTheme.body(color: AdminTheme.textDim)),
          const SizedBox(height: 20),
          OutlinedButton(onPressed: onAdd, child: Text(tr('admin_testimonials_add_first'))),
        ],
      ),
    );
  }
}
