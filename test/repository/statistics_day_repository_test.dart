// import 'package:flutter_test_app/domain/entity/owned_gem.dart';
// import 'package:flutter_test_app/domain/repository/statistics_day_repository.dart';
// import 'package:test/test.dart';
//
// var ownedGems = [
//   OwnedGem(
//     id: 1,
//     gemId: 1,
//     date: '2022-10-13',
//   ),
//   OwnedGem(
//     id: 2,
//     gemId: 1,
//     date: '2022-10-14',
//   ),
//   OwnedGem(
//     id: 3,
//     gemId: 2,
//     date: '2022-10-14',
//   ),
//   OwnedGem(
//     id: 4,
//     gemId: 1,
//     date: '2022-10-15',
//   ),
//   OwnedGem(
//     id: 5,
//     gemId: 1,
//     date: '2022-10-16',
//   ),
// ];
//
// Future<StatisticsDayRepository> _createRepository() async {
//   var ownedGemRepository = TempOwnedGemRepository();
//   await ownedGemRepository.save(ownedGems[0]);
//   await ownedGemRepository.save(ownedGems[1]);
//   await ownedGemRepository.save(ownedGems[2]);
//   await ownedGemRepository.save(ownedGems[3]);
//   await ownedGemRepository.save(ownedGems[4]);
//   return StatisticsDayRepository(ownedGemRepository: ownedGemRepository);
// }
//
// void main() {
//   test('Method getAll must return all items', () async {
//     var repository = await _createRepository();
//
//     var items = await repository.getAll();
//
//     expect(items, hasLength(4));
//   });
//
//
//   test('Method getAllBetween must return all items between dates', () async {
//     var repository = await _createRepository();
//     var dateFrom = '2022-10-14';
//     var dateTo = '2022-10-15';
//
//     var items = await repository.getAllBetween(dateFrom, dateTo);
//
//     expect(items, hasLength(2));
//     expect(items[0].date, dateFrom);
//     expect(items[0].gemCounts.keys, hasLength(2));
//     expect(items[0].gemCounts[1], 1);
//     expect(items[0].gemCounts[2], 1);
//     expect(items[1].date, dateTo);
//     expect(items[1].gemCounts.keys, hasLength(1));
//     expect(items[1].gemCounts[1], 1);
//   });
//
//
//   test('Method getByDate must return item by date', () async {
//     var repository = await _createRepository();
//     var date = '2022-10-14';
//
//     var item = await repository.getByDate(date);
//
//     expect(item.date, date);
//     expect(item.gemCounts.keys, hasLength(2));
//     expect(item.gemCounts[1], 1);
//     expect(item.gemCounts[2], 1);
//   });
// }
