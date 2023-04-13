import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import '../../application/use_case/create_owned_gem/create_owned_gem_use_case.dart';
import '../../application/use_case/create_owned_gem/dto/create_owned_gem_dto.dart';
import '../../application/use_case/delete_owned_gem/delete_owned_gem_use_case.dart';
import '../../application/use_case/delete_owned_gem/dto/delete_owned_gem_dto.dart';
import '../../domain/repository/gem_icon_repository.dart';
import '../../domain/repository/gem_repository.dart';
import '../../domain/repository/owned_gem_repository.dart';

part 'owned_gem_state.dart';

class OwnedGemCubit extends Cubit<OwnedGemState> {
  OwnedGemCubit({
    required this.gemIconRepository,
    required this.gemRepository,
    required this.ownedGemRepository,
    required this.createGemUseCase,
    required this.deleteGemUseCase,
  }) : super(OwnedGemInitial()) {
    gemRepository.addOnChangeHandler(init);
    ownedGemRepository.addOnChangeHandler(init);
    init();
  }

  final GemIconRepository gemIconRepository;
  final GemRepository gemRepository;
  final OwnedGemRepository ownedGemRepository;
  final CreateOwnedGemUseCase createGemUseCase;
  final DeleteOwnedGemUseCase deleteGemUseCase;

  @override
  Future<void> close() {
    gemRepository.deleteOnChangeHandler(init);
    ownedGemRepository.deleteOnChangeHandler(init);
    return super.close();
  }

  Future<void> init() async {
    try {
      final List<Map> gems = [];
      final activeGems = await gemRepository.getAllActive();
      final ownedGems = await ownedGemRepository.getAllByDate(DateTime.now());
      final ownedGemIds = ownedGems.map((gem) => gem.gemId).toSet();
      for (final gem in activeGems) {
        if (ownedGemIds.contains(gem.id)) {
          continue;
        }
        final icon = await gemIconRepository.getById(gem.iconId);
        gems.add({
          'id': gem.id,
          'title': gem.title,
          'color': icon?.getColor(),
        });
      }
      emit(OwnedGemReady(gems: gems));
    } catch (e) {
      emit(OwnedGemError());
    }
  }

  Future<void> addGem(int gemId) async {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');
    final date = formatter.format(now);
    final dto = CreateOwnedGemDto(date: date, gemId: gemId);
    emit(OwnedGemInProgress(gems: state.gems, gemId: gemId));
    try {
      await createGemUseCase.execute(dto);
      emit(OwnedGemSuccess(gems: state.gems, gemId: gemId));
    } catch (e) {
      emit(OwnedGemError(gems: state.gems, gemId: gemId));
    }
  }

  Future<void> deleteGem(int gemId) async {
    final dto = DeleteOwnedGemDto(gemId: gemId);
    emit(OwnedGemInProgress(gems: state.gems, gemId: gemId));
    try {
      await deleteGemUseCase.execute(dto);
      emit(OwnedGemSuccess(gems: state.gems, gemId: gemId));
    } catch (e) {
      emit(OwnedGemError(gems: state.gems, gemId: gemId));
    }
  }
}
