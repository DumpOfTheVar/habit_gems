part of 'settings_cubit.dart';

@immutable
abstract class SettingsState {
  SettingsState({this.settings});

  final Map<String, String>? settings;
}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoadingSuccess extends SettingsState {
  SettingsLoadingSuccess({required super.settings});
}

class SettingsLoadingError extends SettingsState {}

