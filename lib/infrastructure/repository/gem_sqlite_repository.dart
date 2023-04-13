
import 'dart:math';

import 'package:data_provider/data_provider.dart';
import '../../domain/entity/gem.dart';
import '../../domain/repository/gem_repository.dart';

class GemSqliteRepository implements GemRepository {
  GemSqliteRepository({required this.dataProvider});

  final DataProvider dataProvider;
  final List<GemChangeHandler> _handlers = [];

  @override
  Future<List<Gem>> getAll() async {
    final data = await dataProvider.findAll(
      sorter: FieldSorter({'order': true}),
    );
    return data.map((json) => Gem.fromJson(json)).toList();
  }

  @override
  Future<List<Gem>> getAllActive() async {
    final data = await dataProvider.findAll(
      specification: CompareFieldValue<Gem, bool>(
        field: 'isActive',
        value: true,
        operator: Equals<bool>(),
      ),
      sorter: FieldSorter({'order': true}),
    );
    return data.map((json) => Gem.fromJson(json)).toList();
  }

  @override
  Future<List<Gem>> getAllArchived() async {
    final data = await dataProvider.findAll(
      specification: CompareFieldValue<Gem, bool>(
        field: 'isActive',
        value: false,
        operator: Equals<bool>(),
      ),
      sorter: FieldSorter({'order': true}),
    );
    return data.map((json) => Gem.fromJson(json)).toList();
  }

  Future<List<Gem>> getAllBetweenOrder(int fromOrder, int toOrder) async {
    final data = await dataProvider.findAll(
      specification: Between<Gem, int>(
        field: 'order',
        from: fromOrder,
        to: toOrder,
      ),
    );
    return data.map((json) => Gem.fromJson(json)).toList();
  }

  @override
  Future<Gem?> getById(int id) async {
    final json = await dataProvider.findById(id.toString());
    if (json == null) {
      return null;
    }
    return Gem.fromJson(json);
  }

  @override
  Future<int> getMaxOrder() async {
    final data = await dataProvider.findAll();
    if (data.isEmpty) {
      return 0;
    }
    return data.map((json) => json['order'] as int).reduce(max);
  }

  @override
  Future<void> deleteById(int id) async {
    await dataProvider.deleteById(id.toString());
    _onChange();
  }

  @override
  Future<void> save(Gem gem) async {
    final json = gem.toJson();
    await dataProvider.saveOne(json);
    _onChange();
  }

  @override
  void addOnChangeHandler(GemChangeHandler handler) {
    _handlers.add(handler);
  }

  @override
  void deleteOnChangeHandler(GemChangeHandler handler) {
    _handlers.remove(handler);
  }

  void _onChange() {
    for (final handler in _handlers) {
      handler();
    }
  }
}
