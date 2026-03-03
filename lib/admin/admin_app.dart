import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/admin_theme.dart';
import 'feature/shell/presentation/widgets/admin_shell.dart';
import 'feature/shell/cubit/shell_cubit.dart';
import 'feature/dashboard/cubit/dashboard_cubit.dart';
import 'feature/settings/cubit/settings_cubit.dart';
import 'feature/portfolio/cubit/portfolio_cubit.dart';
import 'feature/packages/cubit/packages_cubit.dart';
import 'feature/testimonials/cubit/testimonials_cubit.dart';
import 'feature/booking/cubit/booking_cubit.dart';

/// Root widget for the Admin Dashboard flavor.
class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ShellCubit()),
        BlocProvider(create: (_) => DashboardCubit()..load()),
        BlocProvider(create: (_) => SettingsCubit()..load()),
        BlocProvider(create: (_) => PortfolioCubit()..load()),
        BlocProvider(create: (_) => PackagesCubit()..load()),
        BlocProvider(create: (_) => TestimonialsCubit()..load()),
        BlocProvider(create: (_) => BookingCubit()..load()),
      ],
      child: MaterialApp(
        title: 'Admin Dashboard',
        debugShowCheckedModeBanner: false,
        theme: AdminTheme.dark,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: const AdminShell(),
      ),
    );
  }
}
