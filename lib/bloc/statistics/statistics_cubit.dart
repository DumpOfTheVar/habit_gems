import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import '../../domain/entity/statistics_day.dart';
import '../../domain/repository/gem_icon_repository.dart';
import '../../domain/repository/gem_repository.dart';
import '../../domain/repository/setting_repository.dart';
import '../../domain/repository/statistics_day_repository.dart';

part 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  StatisticsCubit({
    required this.statisticsDayRepository,
    required this.gemRepository,
    required this.gemIconRepository,
    required this.settingRepository,
  }): super(StatisticsInitial()) {
    init();
  }

  final StatisticsDayRepository statisticsDayRepository;
  final GemRepository gemRepository;
  final GemIconRepository gemIconRepository;
  final SettingRepository settingRepository;

  Future<void> init() async {
    emit(StatisticsLoading());
    try {
      final dayStartTime = await settingRepository.getDayStartTime();
      var dateTo = DateTime.now();
      if (dateTo.hour >= int.parse(dayStartTime.substring(0, 2))) {
        dateTo = dateTo.add(Duration(days: 1));
      }
      final dateFrom = dateTo.subtract(Duration(days: 7));
      final formatter = DateFormat('yyyy-MM-dd');
      final data = await statisticsDayRepository.getAllBetween(
        formatter.format(dateFrom),
        formatter.format(dateTo),
      );
      emit(StatisticsLoadingSuccess(data: data, legend: await _getLegend(data)));
    } catch (e) {
      emit(StatisticsLoadingError());
    }
  }

  Future<Map<int, Map<String, dynamic>>> _getLegend(List<StatisticsDay> data) async {
    final gemIds = <int>{};
    for (final day in data) {
      gemIds.addAll(day.gemCounts.keys);
    }
    final legend = <int, Map<String, dynamic>>{};
    for (final gemId in gemIds) {
      final gem = (await gemRepository.getById(gemId))!;
      final icon = (await gemIconRepository.getById(gem.iconId))!;
      legend[gemId] = {
        'title': gem.title,
        'color': icon.getColor(),
      };
    }
    return legend;
  }
}
