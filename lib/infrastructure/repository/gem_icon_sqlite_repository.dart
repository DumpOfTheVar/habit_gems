
import 'package:data_provider/data_provider.dart';
import '../../domain/entity/gem_icon.dart';
import '../../domain/repository/gem_icon_repository.dart';

class GemIconSqliteRepository implements GemIconRepository {
  GemIconSqliteRepository({required this.dataProvider});

  final DataProvider dataProvider;

  @override
  Future<GemIcon?> getById(int id) async {
    final json = await dataProvider.findById(id.toString());
    if (json == null) {
      return null;
    }
    return GemIcon.fromJson(json);
  }

  @override
  Future<List<GemIcon>> getAll() async {
    final data = await dataProvider.findAll();
    return data.map((json) => GemIcon.fromJson(json)).toList();
  }

  @override
  Future<void> save(GemIcon gemIcon) async {
    final json = gemIcon.toJson();
    await dataProvider.saveOne(json);
  }

  @override
  Future<void> deleteById(int id) async {
    await dataProvider.deleteById(id.toString());
  }
}