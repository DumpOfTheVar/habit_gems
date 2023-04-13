import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import '../../domain/entity/gem.dart';
import '../../domain/repository/gem_icon_repository.dart';
import '../../domain/repository/gem_repository.dart';
import '../../domain/repository/owned_gem_repository.dart';
import '../../domain/repository/setting_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required this.gemIconRepository,
    required this.gemRepository,
    required this.ownedGemRepository,
    required this.settingRepository
  }) : super(HomeInitial()) {
    refresh();
    ownedGemRepository.addOnChangeHandler(refresh);
  }

  final GemIconRepository gemIconRepository;
  final GemRepository gemRepository;
  final OwnedGemRepository ownedGemRepository;
  final SettingRepository settingRepository;

  @override
  Future<void> close() {
    ownedGemRepository.deleteOnChangeHandler(refresh);
    return super.close();
  }

  Future<void> refresh() async {
    emit(HomeLoading(gems: state.gems));
    try {
      final ownedGems = await ownedGemRepository.getAllByDate(DateTime.now());
      final Map<int, Map> gems = {};
      for (final ownedGem in ownedGems) {
        if (!gems.containsKey(ownedGem.gemId)) {
          final gem = await gemRepository.getById(ownedGem.gemId);
          if (gem == null) {
            continue;
          }
          final gemIcon = await gemIconRepository.getById(gem.iconId);
          if (gemIcon == null) {
            continue;
          }
          gems[ownedGem.gemId] = {
            'gemId': gem.id,
            'title': gem.title,
            'color': gemIcon.getColor(),
            'count': 0,
            'goalCount': gem.goalCount,
            'goalCompleted': await _getGoalCompleted(gem),
            'order': gem.order,
          };
        }
        gems[ownedGem.gemId]!['count'] = gems[ownedGem.gemId]!['count']! + 1;
      }
      final sortedGems = Map.fromEntries(gems.entries.toList()..sort(
          (e1, e2) => e1.value['order'].compareTo(e2.value['order'])));
      emit(HomeLoadingSuccess(gems: sortedGems));
    } catch (e) {
      emit(HomeLoadingError(gems: state.gems));
    }
  }

  Future<int> _getGoalCompleted(Gem gem) async {
    final now = DateTime.now();
    DateTime? startDate;
    switch (gem.goalPeriod) {
      case GoalPeriod.day:
        return 0;
      case GoalPeriod.week:
        startDate = DateTime(now.year, now.month, 1);
        break;
      case GoalPeriod.month:
        startDate = now.subtract(Duration(days: now.weekday - 1));
    }
    final formatter = DateFormat('yyyy-MM-dd');
    return ownedGemRepository.getCountByGemId(gem.id!,
        formatter.format(startDate), formatter.format(now));
  }
}
