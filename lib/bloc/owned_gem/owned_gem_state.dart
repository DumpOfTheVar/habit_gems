part of 'owned_gem_cubit.dart';

@immutable
abstract class OwnedGemState {
  OwnedGemState({this.gems, this.gemId});

  final int? gemId;
  final List<Map>? gems;
}

class OwnedGemInitial extends OwnedGemState {
  OwnedGemInitial();
}

class OwnedGemReady extends OwnedGemState {
  OwnedGemReady({required super.gems, super.gemId});
}

class OwnedGemInProgress extends OwnedGemState {
  OwnedGemInProgress({required super.gems, super.gemId});
}

class OwnedGemSuccess extends OwnedGemState {
  OwnedGemSuccess({required super.gems, super.gemId});
}

class OwnedGemError extends OwnedGemState {
  OwnedGemError({super.gems, super.gemId});
}
