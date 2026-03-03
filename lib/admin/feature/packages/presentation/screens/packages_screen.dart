import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photgraphy_system/admin/core/models/package_model.dart';
import 'package:photgraphy_system/admin/core/theme/admin_theme.dart';
import 'package:photgraphy_system/admin/feature/packages/cubit/packages_cubit.dart';
import 'package:photgraphy_system/admin/feature/packages/cubit/packages_state.dart';
import '../widgets/package_row.dart';
import '../widgets/package_dialog.dart';

class PackagesScreen extends StatelessWidget {
  const PackagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale; // Trigger rebuild on locale change
    return BlocBuilder<PackagesCubit, PackagesState>(
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
              Row(
                children: [
                  Text(
                    '${tr("admin_packages_title")} (${state.packages.length})',
                    style: AdminTheme.headline(22),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () => _showDialog(context),
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: Text(tr('admin_packages_add')),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (state.packages.isEmpty)
                _EmptyState(onAdd: () => _showDialog(context))
              else
                ...state.packages.map((pkg) => PackageRow(
                      package: pkg,
                      onEdit: () => _showDialog(context, existing: pkg),
                      onDelete: () =>
                          context.read<PackagesCubit>().delete(pkg.id),
                    )),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showDialog(BuildContext context,
      {PackageModel? existing}) async {
    final result = await showPackageDialog(context, existing: existing);
    if (result != null && context.mounted) {
      context.read<PackagesCubit>().save(result);
    }
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
          const Icon(Icons.inventory_2_rounded,
              size: 48, color: AdminTheme.textDim),
          const SizedBox(height: 16),
          Text(tr('admin_packages_empty'),
              style: AdminTheme.body(color: AdminTheme.textDim)),
          const SizedBox(height: 20),
          OutlinedButton(
              onPressed: onAdd,
              child: Text(tr('admin_packages_add_first'))),
        ],
      ),
    );
  }
}
