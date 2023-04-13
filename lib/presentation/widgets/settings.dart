
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings_ui/settings_ui.dart';
import '../../bloc/settings/settings_cubit.dart';

class Settings extends StatelessWidget {
  Settings({super.key, required this.settings});

  final Map<String, String> settings;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SettingsList(
      lightTheme: SettingsThemeData(
        titleTextColor: theme.hintColor,
        settingsListBackground: theme.colorScheme.background,
        settingsSectionBackground: theme.colorScheme.background,
      ),
      darkTheme: SettingsThemeData(
        titleTextColor: theme.hintColor,
        settingsListBackground: theme.colorScheme.background,
        settingsSectionBackground: theme.colorScheme.background,
      ),
      sections: [
        SettingsSection(
          title: Text('Appearance'),
          tiles: <SettingsTile>[
            SettingsTile.switchTile(
              title: Text('Dark theme'),
              initialValue: int.parse(settings['dark_theme'] ?? '0') != 0,
              activeSwitchColor: theme.colorScheme.secondary,
              onToggle: (bool value) {
                context.read<SettingsCubit>().updateSetting('dark_theme', value? '1' : '0');
              },
            ),
          ],
        ),
        SettingsSection(
          title: Text('Date and Time'),
          tiles: <SettingsTile>[
            SettingsTile.switchTile(
              title: Text('New day at 4am'),
              initialValue: int.parse(settings['shift_day_start'] ?? '0') != 0,
              activeSwitchColor: theme.colorScheme.secondary,
              onToggle: (bool value) {
                context.read<SettingsCubit>().updateSetting('shift_day_start', value? '1' : '0');
              },
            ),
          ],
        ),
      ],
    );
  }

}