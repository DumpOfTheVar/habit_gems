import 'package:data_provider/data_provider.dart';
import '../../domain/entity/setting.dart';
import '../../domain/repository/setting_repository.dart';

class SettingSqliteRepository implements SettingRepository {
  SettingSqliteRepository({required this.dataProvider});

  final DataProvider dataProvider;

  @override
  Future<Setting?> getById(int id) async {
    final json = await dataProvider.findById(id.toString());
    if (json == null) {
      return null;
    }
    return Setting.fromJson(json);
  }

  @override
  Future<Setting?> getByName(String name) async {
    final json = await dataProvider.findOne(
      specification: CompareFieldValue<Setting, String>(
        field: 'name',
        operator: Equals<String>(),
        value: name,
      ),
    );
    if (json == null) {
      return null;
    }
    return Setting.fromJson(json);
  }

  @override
  Future<List<Setting>> getAll() async {
    final data = await dataProvider.findAll();
    return data.map((json) => Setting.fromJson(json)).toList();
  }

  @override
  Future<String> getDayStartTime() async {
    final setting = await getByName('shift_day_start');
    return (setting?.value ?? '0') == '0' ? '00:00:00' : '04:00:00';
  }

  @override
  Future<void> save(Setting setting) async {
    final json = setting.toJson();
    await dataProvider.saveOne(json);
  }
}
