import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../application/use_case/archive_gem/archive_gem_use_case.dart';
import '../../application/use_case/delete_gem/delete_gem_use_case.dart';
import '../../application/use_case/delete_gem/dto/delete_gem_dto.dart';
import '../../application/use_case/update_gem_order/update_gem_order_use_case.dart';
import '../../application/use_case/update_gem_order/dto/update_gem_order_dto.dart';
import '../../domain/entity/gem.dart';
import '../../domain/repository/gem_icon_repository.dart';
import '../../domain/repository/gem_repository.dart';

part 'gem_list_state.dart';

class GemListCubit extends Cubit<GemListState> {
  GemListCubit({
    required this.gemIconRepository,
    required this.gemRepository,
    required this.updateGemOrderUseCase,
    required this.archiveGemUseCase,
    required this.deleteGemUseCase,
  }) : super(GemListInitial(filter: GemFilterOption.all)) {
    gemRepository.addOnChangeHandler(refresh);
    refresh();
  }

  final GemIconRepository gemIconRepository;
  final GemRepository gemRepository;
  final UpdateGemOrderUseCase updateGemOrderUseCase;
  final ArchiveGemUseCase archiveGemUseCase;
  final DeleteGemUseCase deleteGemUseCase;

  @override
  Future<void> close() {
    gemRepository.addOnChangeHandler(refresh);
    return super.close();
  }

  Future<void> refresh() async {
    emit(GemListLoading.fromState(state));
    // try {
      final gems = await _mapFilter(state.filter)();
      final items = await Future.wait(gems.map(_mapGem));
      emit(GemListLoadingSuccess(gems: items, filter: state.filter));
    // } catch (e) {
    //   emit(GemListLoadingError.fromState(state));
    // }
  }

  Future<void> filter(GemFilterOption filter) async {
    emit(GemListInitial(gems: state.gems, filter: filter));
    await refresh();
  }

  Future<void> updateOrder(int oldIndex, int newIndex) async {
    // try {
      final gemId = state.gems![oldIndex]['id'];
      final order = state.gems![newIndex]['order'];
      final dto = UpdateGemOrderDto(id: gemId, order: order);
      await updateGemOrderUseCase.execute(dto);
      await refresh();
    // } catch (e) {
    //   // TODO: error message
    // }
  }

  Future<void> archive(int gemId) async {
    try {
      await archiveGemUseCase.execute(gemId);
      await refresh();
    } catch (e) {
      // TODO: error message
    }
  }

  Future<void> delete(int gemId) async {
    try {
      await deleteGemUseCase.execute(DeleteGemDto(gemId: gemId));
      await refresh();
    } catch (e) {
      // TODO: error message
    }
  }

  Future<Map<String, dynamic>> _mapGem(Gem gem) async {
    final gemIcon = await gemIconRepository.getById(gem.iconId);
    return {
      'id': gem.id,
      'title': gem.title,
      'color': gemIcon!.getColor(),
      'order': gem.order,
      'isActive': gem.isActive,
    };
  }

  Future<List<Gem>> Function() _mapFilter(GemFilterOption filter) {
    switch (filter) {
      case GemFilterOption.all:
        return gemRepository.getAll;
      case GemFilterOption.active:
        return gemRepository.getAllActive;
      case GemFilterOption.archived:
        return gemRepository.getAllArchived;
    }
  }
}
