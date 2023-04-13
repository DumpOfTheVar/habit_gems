
import '../entity/setting.dart';

abstract class SettingRepository {
  Future<Setting?> getById(int id);
  Future<Setting?> getByName(String name);
  Future<List<Setting>> getAll();
  Future<String> getDayStartTime();
  Future<void> save(Setting setting);
}

class SettingRepositoryEvent {
  SettingRepositoryEvent({required this.settings});

  final Map<String, Setting> settings;
}