import 'package:intl/intl.dart';
import '../entity/owned_gem.dart';
import '../entity/statistics_day.dart';
import 'gem_repository.dart';
import 'owned_gem_repository.dart';
import 'setting_repository.dart';

class StatisticsDayRepository {
  StatisticsDayRepository({
    required this.gemRepository,
    required this.ownedGemRepository,
    required this.settingRepository,
  });

  GemRepository gemRepository;
  OwnedGemRepository ownedGemRepository;
  SettingRepository settingRepository;

  Future<List<StatisticsDay>> getAll() async {
    final ownedGems = await ownedGemRepository.getAll();
    return _ownedGemsToStatisticsDays(ownedGems);
  }

  Future<List<StatisticsDay>> getAllBetween(String dateFrom, String dateTo) async {
    final ownedGems = await ownedGemRepository.getAllBetween(dateFrom, dateTo);
    return _ownedGemsToStatisticsDays(ownedGems);
  }

  Future<StatisticsDay> getByDate(String date) async {
    final ownedGems = await ownedGemRepository.getAllByDate(
      DateTime.parse(date),
    );
    if (ownedGems.isEmpty) {
      return _makeStatisticsDay(date);
    }
    return (await _ownedGemsToStatisticsDays(ownedGems)).first;
  }

  Future<List<StatisticsDay>> _ownedGemsToStatisticsDays(List<OwnedGem> ownedGems) async {
    Map<String, StatisticsDay> statisticDays = {};
    final gemIds = ownedGems.map((e) => e.gemId).toSet();
    final gemOrders = <int, int>{};
    for (final gemId in gemIds) {
      final gem = (await gemRepository.getById(gemId))!;
      gemOrders[gemId] = gem.order;
    }
    ownedGems.sort((a, b) => gemOrders[a.gemId]!.compareTo(gemOrders[b.gemId]!));
    final keyFormatter = DateFormat('MM-dd');
    ownedGems.forEach((OwnedGem ownedGem) {
      final key = keyFormatter.format(ownedGem.day);
      if (!statisticDays.containsKey(key)) {
        statisticDays[key] = _makeStatisticsDay(key);
      }
      final statisticDay = statisticDays[key]!;
      if (!statisticDay.gemCounts.containsKey(ownedGem.gemId)) {
        statisticDay.gemCounts[ownedGem.gemId] = 0;
      }
      statisticDay.gemCounts[ownedGem.gemId] =
          statisticDay.gemCounts[ownedGem.gemId]! + 1;
    });
    final result = statisticDays.values.toList();
    result.sort((a, b) => a.date.compareTo(b.date));
    return result;
  }

  StatisticsDay _makeStatisticsDay(String date) {
    return StatisticsDay(date: date, gemCounts: {});
  }
}