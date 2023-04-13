import 'package:data_provider/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entity/owned_gem.dart';
import '../../domain/repository/setting_repository.dart';
import '../../domain/repository/owned_gem_repository.dart';

class OwnedGemSqliteRepository implements OwnedGemRepository {
  OwnedGemSqliteRepository({
    required this.dataProvider,
    required this.settingRepository,
  });

  final DataProvider dataProvider;
  final SettingRepository settingRepository;
  final List<OwnedGemChangeHandler> _handlers = [];

  @override
  Future<List<OwnedGem>> getAll() async {
    final data = await dataProvider.findAll(
      sorter: FieldSorter({'gemId': true, 'id': true}),
    );
    return data.map((json) => OwnedGem.fromJson(json)).toList();
  }

  @override
  Future<List<OwnedGem>> getAllBetween(String dateFrom, String dateTo) async {
    final data = await dataProvider.findAll(
      specification: Between<OwnedGem, String>(
        field: 'date',
        from: dateFrom,
        to: dateTo,
      ),
      sorter: FieldSorter({'gemId': true, 'id': true}),
    );
    return data.map((json) => OwnedGem.fromJson(json)).toList();
  }

  @override
  Future<List<OwnedGem>> getAllByDate(DateTime date, [String? dayStartTime]) async {
    if (dayStartTime == null) {
      dayStartTime = await settingRepository.getDayStartTime();
    }
    final day = await getDay(date, dayStartTime);
    final formatter = DateFormat('yyyy-MM-dd ' + dayStartTime);
    final dateFrom = formatter.format(day);
    final dateTo = formatter.format(day.add(Duration(days: 1)));
    return getAllBetween(dateFrom, dateTo);
  }

  @override
  Future<OwnedGem?> getById(int id) async {
    final json = await dataProvider.findById(id.toString());
    if (json == null) {
      return null;
    }
    return OwnedGem.fromJson(json);
  }

  @override
  Future<OwnedGem?> getLastByGemId(int gemId) async {
    final json = await dataProvider.findOne(
      specification: CompareFieldValue<OwnedGem, int>(
        field: 'gemId',
        operator: Equals<int>(),
        value: gemId,
      ),
      sorter: FieldSorter<OwnedGem>({'date': false}),
    );
    if (json == null) {
      return null;
    }
    return OwnedGem.fromJson(json);
  }

  @override
  Future<int> getCountByGemId(int gemId, [String? dateFrom, String? dateTo]) async {
    final conditions = <CompareFieldValue<OwnedGem, Object?>>[];
    conditions.add(CompareFieldValue<OwnedGem, int>(
      field: 'gemId',
      value: gemId,
      operator: Equals<int>(),
    ));
    if (dateFrom != null) {
      conditions.add(CompareFieldValue<OwnedGem, String>(
        field: 'date',
        value: dateFrom,
        operator: GreaterOrEquals<String>(),
      ));
    }
    if (dateTo != null) {
      conditions.add(CompareFieldValue<OwnedGem, String>(
        field: 'date',
        value: dateTo,
        operator: Less<String>(),
      ));
    }
    final data = await dataProvider.findAll(
      specification: And<OwnedGem>(conditions),
      sorter: FieldSorter({'gemId': true, 'id': true}),
    );
    return data.length;
  }

  @override
  Future<void> save(OwnedGem ownedGem) async {
    final json = ownedGem.toJson();
    await dataProvider.saveOne(json);
    _onChange();
  }

  @override
  Future<void> deleteById(int id) async {
    await dataProvider.deleteById(id.toString());
    _onChange();
  }

  @override
  Future<void> deleteAllByGemId(int gemId) async {
    await dataProvider.deleteAll(CompareFieldValue<OwnedGem, int>(
      field: 'gemId',
      value: gemId,
      operator: Equals<int>(),
    ));
    _onChange();
  }

  @override
  Future<DateTime> getDay(DateTime date, [String? dayStartTime]) async {
    if (dayStartTime == null) {
      dayStartTime = await settingRepository.getDayStartTime();
    }
    if (date.hour < int.parse(dayStartTime.substring(0, 2))) {
      date = date.subtract(Duration(days: 1));
    }
    return DateUtils.dateOnly(date);
  }

  @override
  void addOnChangeHandler(OwnedGemChangeHandler handler) {
    _handlers.add(handler);
  }

  @override
  void deleteOnChangeHandler(OwnedGemChangeHandler handler) {
    _handlers.remove(handler);
  }

  void _onChange() {
    for (final handler in _handlers) {
      handler();
    }
  }
}