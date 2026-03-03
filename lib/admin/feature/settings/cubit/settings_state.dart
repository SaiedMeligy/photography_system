import 'package:equatable/equatable.dart';
import '../../../core/models/site_settings.dart';

enum SaveStatus { idle, saving, success, error }

class SettingsState extends Equatable {
  final SiteSettings? settings;
  final bool isLoading;
  final SaveStatus saveStatus;

  const SettingsState({
    this.settings,
    this.isLoading = true,
    this.saveStatus = SaveStatus.idle,
  });

  SettingsState copyWith({
    SiteSettings? settings,
    bool? isLoading,
    SaveStatus? saveStatus,
  }) {
    return SettingsState(
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
      saveStatus: saveStatus ?? this.saveStatus,
    );
  }

  @override
  List<Object?> get props => [settings, isLoading, saveStatus];
}
