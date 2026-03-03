import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/site_settings.dart';
import '../../../core/services/admin_data_service.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  void load() {
    final s = AdminDataService.getSiteSettings() ?? SiteSettings();
    emit(state.copyWith(settings: s, isLoading: false));
  }

  Future<void> save(SiteSettings updated) async {
    emit(state.copyWith(saveStatus: SaveStatus.saving));
    await AdminDataService.saveSiteSettings(updated);
    emit(state.copyWith(settings: updated, saveStatus: SaveStatus.success));
    await Future.delayed(const Duration(seconds: 2));
    emit(state.copyWith(saveStatus: SaveStatus.idle));
  }
}
