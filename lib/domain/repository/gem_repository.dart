
import '../entity/gem.dart';

abstract class GemRepository {
  Future<List<Gem>> getAll();
  Future<List<Gem>> getAllActive();
  Future<List<Gem>> getAllArchived();
  Future<List<Gem>> getAllBetweenOrder(int fromOrder, int toOrder);
  Future<Gem?> getById(int id);
  Future<int> getMaxOrder();
  Future<void> deleteById(int id);
  Future<void> save(Gem gem);
  void addOnChangeHandler(GemChangeHandler handler);
  void deleteOnChangeHandler(GemChangeHandler handler);
}

typedef void GemChangeHandler();