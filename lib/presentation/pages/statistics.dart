import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';
import '../../bloc/statistics/statistics_cubit.dart';
import '../../domain/repository/gem_icon_repository.dart';
import '../../domain/repository/gem_repository.dart';
import '../../domain/repository/setting_repository.dart';
import '../../domain/repository/statistics_day_repository.dart';
import '../widgets/statistics_chart.dart';
import 'base_page.dart';

class StatisticsPage extends BasePage {
  @override
  String? getPrevious(BuildContext context) {
    return '/';
  }

  @override
  Widget getTitle(BuildContext context) {
    return const Text('Statistics');
  }

  @override
  Widget getBody(BuildContext context) {
    return BlocProvider<StatisticsCubit>(
      create: (context) => StatisticsCubit(
        statisticsDayRepository: context.read<StatisticsDayRepository>(),
        gemRepository: context.read<GemRepository>(),
        gemIconRepository: context.read<GemIconRepository>(),
        settingRepository: context.read<SettingRepository>(),
      ),
      child: BlocConsumer<StatisticsCubit, StatisticsState>(
        builder: (context, state) => StatisticsChart(
          data: state.data ?? [],
          legend: state.legend ?? {},
        ),
        listener: (context, state) {
          if (state is StatisticsLoadingError) {
            final theme = Theme.of(context);
            showSimpleNotification(
              Text('Error'),
              background: theme.colorScheme.error,
            );
            return;
          }
        },
      ),
    );
  }

  @override
  List<Widget> getActions(BuildContext context) {
    return [];
  }

  @override
  Widget? getButton(BuildContext context) {
    return null;
  }
}