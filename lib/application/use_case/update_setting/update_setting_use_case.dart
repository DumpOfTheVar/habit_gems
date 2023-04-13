
import 'dto/update_setting_dto.dart';
import '../../../domain/entity/setting.dart';
import '../../../domain/repository/setting_repository.dart';

class UpdateSettingUseCase {
  UpdateSettingUseCase({required this.repository});

  final SettingRepository repository;

  Future<void> execute(UpdateSettingDto dto) async {
    Setting? setting = await repository.getByName(dto.name);
    if (setting == null) {
      setting = new Setting(name: dto.name, value: dto.value);
    } else {
      setting.value = dto.value;
    }
    await repository.save(setting);
  }
}