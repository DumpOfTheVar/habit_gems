part of 'home_cubit.dart';

@immutable
abstract class HomeState {
  HomeState({this.gems});

  final Map<int, Map>? gems;
}

class HomeInitial extends HomeState {
}

class HomeLoading extends HomeState {
  HomeLoading({super.gems});
}

class HomeLoadingSuccess extends HomeState {
  HomeLoadingSuccess({required super.gems});
}

class HomeLoadingError extends HomeState {
  HomeLoadingError({super.gems});
}
