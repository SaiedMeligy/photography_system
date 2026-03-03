import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photgraphy_system/admin/core/models/portfolio_category.dart';
import 'package:photgraphy_system/admin/core/theme/admin_theme.dart';
import 'package:photgraphy_system/admin/feature/portfolio/cubit/portfolio_cubit.dart';
import 'package:photgraphy_system/admin/feature/portfolio/cubit/portfolio_state.dart';
import '../widgets/category_card.dart';
import '../widgets/category_dialog.dart';
import '../widgets/images_dialog.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale; // Trigger rebuild on locale change
    return BlocBuilder<PortfolioCubit, PortfolioState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
              child: CircularProgressIndicator(color: AdminTheme.gold));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(count: state.categories.length),
              const SizedBox(height: 24),
              if (state.categories.isEmpty)
                _EmptyState(
                  icon: Icons.photo_library_rounded,
                  message: tr('admin_portfolio_empty'),
                  actionLabel: tr('admin_portfolio_add_first'),
                  onAction: () =>
                      _showAddDialog(context),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 340,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: state.categories.length,
                  itemBuilder: (_, i) {
                    final cat = state.categories[i];
                    return CategoryCard(
                      category: cat,
                      onEdit: () => _showEditDialog(context, cat),
                      onDelete: () => _confirmDelete(context, cat),
                      onManageImages: () =>
                          _showImagesDialog(context, cat),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showAddDialog(BuildContext context) async {
    final cat = await showCategoryDialog(context);
    if (cat != null && context.mounted) {
      context.read<PortfolioCubit>().addCategory(cat);
    }
  }

  Future<void> _showEditDialog(
      BuildContext context, PortfolioCategory cat) async {
    final updated = await showCategoryDialog(context, existing: cat);
    if (updated != null && context.mounted) {
      context.read<PortfolioCubit>().updateCategory(updated);
    }
  }

  Future<void> _confirmDelete(
      BuildContext context, PortfolioCategory cat) async {
    final confirmed = await showConfirmDialog(
      context,
      title: tr('admin_delete_title'),
      message: tr('admin_portfolio_confirm_delete', namedArgs: {'name': cat.nameAr.isNotEmpty ? cat.nameAr : cat.name}),
    );
    if (confirmed && context.mounted) {
      context.read<PortfolioCubit>().deleteCategory(cat.id);
    }
  }

  Future<void> _showImagesDialog(
      BuildContext context, PortfolioCategory cat) async {
    await showImagesDialog(context, cat: cat, cubit: context.read<PortfolioCubit>());
  }
}

// ─── Header ───────────────────────────────────────────────────
class _Header extends StatelessWidget {
  final int count;
  const _Header({required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '${tr("admin_portfolio_title")} ($count)',
          style: AdminTheme.headline(22),
        ),
        const Spacer(),
        ElevatedButton.icon(
          onPressed: () async {
            final cat = await showCategoryDialog(context);
            if (cat != null && context.mounted) {
              context.read<PortfolioCubit>().addCategory(cat);
            }
          },
          icon: const Icon(Icons.add_rounded, size: 18),
          label: Text(tr('admin_portfolio_add')),
        ),
      ],
    );
  }
}

// ─── Shared helpers re-exported from here ─────────────────────
class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  const _EmptyState({
    required this.icon,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(icon, size: 48, color: AdminTheme.textDim),
          const SizedBox(height: 16),
          Text(message, style: AdminTheme.body(color: AdminTheme.textDim)),
          const SizedBox(height: 20),
          OutlinedButton(
              onPressed: onAction, child: Text(actionLabel)),
        ],
      ),
    );
  }
}
