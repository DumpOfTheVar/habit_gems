import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:overlay_support/overlay_support.dart';
import '../../application/use_case/update_setting/update_setting_use_case.dart';
import '../../bloc/app/app_cubit.dart';
import '../../bloc/settings/settings_cubit.dart';
import '../../domain/repository/setting_repository.dart';
import '../pages/base_page.dart';
import '../widgets/settings.dart';

class SettingsPage extends BasePage {
  @override
  String? getPrevious(BuildContext context) {
    return '/';
  }

  @override
  Widget getTitle(BuildContext context) {
    return Text('Settings');
  }

  @override
  Widget getBody(BuildContext context) {
    return BlocProvider<SettingsCubit>(
      create: (context) => SettingsCubit(
        settingRepository: context.read<SettingRepository>(),
        updateSettingUseCase: UpdateSettingUseCase(
          repository: context.read<SettingRepository>(),
        ),
        appCubit: context.read<AppCubit>(),
      ),
      child: BlocConsumer<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (state is SettingsInitial || state is SettingsLoading) {
            return Container(child: SpinKitRing(color: Colors.blue));
          }
          if (state is SettingsLoadingError) {
            return Container(child: Text('Error'));
          }
          if (state is SettingsLoadingSuccess) {
            return Settings(settings: state.settings ?? {});
          }
          return Container(child: Text('Undefined state'));
        },
        listener: (context, state) {
          if (state is SettingsLoadingError) {
            final theme = Theme.of(context);
            showSimpleNotification(
              Text('Error'),
              background: theme.colorScheme.error,
            );
            return;
          }
        },
      ),
    );
  }

  @override
  List<Widget> getActions(BuildContext context) {
    return [];
  }

  @override
  Widget? getButton(BuildContext context) {
    return null;
  }
}