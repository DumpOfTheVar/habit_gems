
import '../entity/gem_icon.dart';

abstract class GemIconRepository {
  Future<List<GemIcon>> getAll();
  Future<GemIcon?> getById(int id);
  Future<void> deleteById(int id);
  Future<void> save(GemIcon gemIcon);
}