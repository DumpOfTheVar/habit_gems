import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../app/app_cubit.dart';
import '../../application/use_case/update_setting/dto/update_setting_dto.dart';
import '../../application/use_case/update_setting/update_setting_use_case.dart';
import '../../domain/repository/setting_repository.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required this.settingRepository,
    required this.updateSettingUseCase,
    required this.appCubit,
  }) : super(SettingsInitial()) {
    init();
  }

  final SettingRepository settingRepository;
  final UpdateSettingUseCase updateSettingUseCase;
  final AppCubit appCubit;

  Future<void> init() async {
    emit(SettingsLoading());
    try {
      final settings = await settingRepository.getAll();
      final data = <String, String>{};
      for (final setting in settings) {
        data[setting.name] = setting.value;
      }
      emit(SettingsLoadingSuccess(settings: data));
    } catch (e) {
      emit(SettingsLoadingError());
    }
  }

  Future<void> updateSetting(String name, String value) async {
    final settings = state.settings!;
    settings[name] = value;
    final dto = UpdateSettingDto(name: name, value: value);
    await updateSettingUseCase.execute(dto);
    emit(SettingsLoadingSuccess(settings: settings));
    if (name == 'dark_theme') {
      appCubit.updateTheme(value == '1');
    }
  }
}
