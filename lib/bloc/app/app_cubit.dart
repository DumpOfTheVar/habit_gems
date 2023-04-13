import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../domain/repository/setting_repository.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit({
    required this.settingRepository,
  }): super(AppState(theme: _getLightTheme())) {
    init();
  }

  SettingRepository settingRepository;

  Future<void> init() async {
    final themeSetting = await settingRepository.getByName('dark_theme');
    ThemeData? theme;
    if (themeSetting == null || themeSetting.value == '0') {
      theme = _getLightTheme();
    } else {
      theme = _getDarkTheme();
    }
    emit(AppState(theme: theme));
  }

  void updateTheme(bool isDark) {
    final theme = isDark ? _getDarkTheme() : _getLightTheme();
    emit(AppState(theme: theme));
  }

  static ThemeData _getLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: const Color(0xFF259950),
        onPrimary: const Color(0xFFEEEEEE),
        secondary: const Color(0xFF35C877),
        onSecondary: const Color(0xFFEEEEEE),
        error: const Color(0xFFDD0000),
        onError: const Color(0xFFEEEEEE),
        background: const Color(0xFFEEEEEE),
        onBackground: const Color(0xFF111111),
        surface: const Color(0xFFEEEEEE),
        onSurface: const Color(0xFF111111),
      ),
      disabledColor: Colors.black12,
      hintColor: Colors.black54,
    );
  }

  static ThemeData _getDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: const Color(0xFF393E46),
        onPrimary: const Color(0xFFEEEEEE),
        secondary: const Color(0xFF35C877),
        onSecondary: const Color(0xFFEEEEEE),
        error: const Color(0xFFDD0000),
        onError: const Color(0xFFEEEEEE),
        background: const Color(0xFF232325),
        onBackground: const Color(0xFFEEEEEE),
        surface: const Color(0xFF232325),
        onSurface: const Color(0xFFEEEEEE),
      ),
      disabledColor: Colors.white24,
      hintColor: Colors.white60,
    );
  }
}
