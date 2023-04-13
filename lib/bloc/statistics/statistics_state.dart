part of 'statistics_cubit.dart';

@immutable
abstract class StatisticsState {
  StatisticsState({this.data, this.legend});

  final List<StatisticsDay>? data;
  final Map<int, Map<String, dynamic>>? legend;
}

class StatisticsInitial extends StatisticsState {}

class StatisticsLoading extends StatisticsState {}

class StatisticsLoadingSuccess extends StatisticsState {
  StatisticsLoadingSuccess({required super.data, required super.legend});
}

class StatisticsLoadingError extends StatisticsState {}