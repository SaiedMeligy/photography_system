import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'admin/core/services/admin_data_service.dart';
import 'admin/admin_app.dart';

/// Entry point for the Admin Dashboard flavor.
/// Run with:  flutter run -t lib/main_admin.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await AdminDataService.init();
  
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const AdminApp(),
    ),
  );
}
