part of 'gem_list_cubit.dart';

enum GemFilterOption {
  all,
  active,
  archived,
}

@immutable
abstract class GemListState {
  GemListState({this.gems, required this.filter});

  final List<Map<String, dynamic>>? gems;
  final GemFilterOption filter;
}

class GemListInitial extends GemListState {
  GemListInitial({super.gems, required super.filter});
  factory GemListInitial.fromState(GemListState state) {
    return GemListInitial(gems: state.gems, filter: state.filter);
  }
}

class GemListLoading extends GemListState {
  GemListLoading({super.gems, required super.filter});
  factory GemListLoading.fromState(GemListState state) {
    return GemListLoading(gems: state.gems, filter: state.filter);
  }
}

class GemListLoadingSuccess extends GemListState {
  GemListLoadingSuccess({required super.gems, required super.filter});
  factory GemListLoadingSuccess.fromState(GemListState state) {
    return GemListLoadingSuccess(gems: state.gems, filter: state.filter);
  }
}

class GemListLoadingError extends GemListState {
  GemListLoadingError({super.gems, required super.filter});
  factory GemListLoadingError.fromState(GemListState state) {
    return GemListLoadingError(gems: state.gems, filter: state.filter);
  }
}
