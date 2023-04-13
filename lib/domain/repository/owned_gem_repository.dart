
import '../entity/owned_gem.dart';

abstract class OwnedGemRepository {
  Future<List<OwnedGem>> getAll();
  Future<List<OwnedGem>> getAllBetween(String dateFrom, String dateTo);
  Future<List<OwnedGem>> getAllByDate(DateTime date, [String? dayStartTime]);
  Future<OwnedGem?> getById(int id);
  Future<OwnedGem?> getLastByGemId(int gemId);
  Future<int> getCountByGemId(int gemId, [String? dateFrom, String? dateTo]);
  Future<void> save(OwnedGem ownedGem);
  Future<void> deleteById(int id);
  Future<void> deleteAllByGemId(int gemId);
  Future<DateTime> getDay(DateTime date, [String? dayStartTime]);
  void addOnChangeHandler(OwnedGemChangeHandler handler);
  void deleteOnChangeHandler(OwnedGemChangeHandler handler);
}

typedef void OwnedGemChangeHandler();