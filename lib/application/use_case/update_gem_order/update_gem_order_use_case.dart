
import 'dto/update_gem_order_dto.dart';
import '../../../domain/repository/gem_repository.dart';

class UpdateGemOrderUseCase {
  UpdateGemOrderUseCase({required this.gemRepository});

  final GemRepository gemRepository;

  Future<bool> execute(UpdateGemOrderDto dto) async {
    final gem = await gemRepository.getById(dto.id);
    if (gem == null) {
      throw Exception('Failed to find gem with id: ' + dto.id.toString());
    }
    final int fromOrder;
    final int toOrder;
    final int diff;
    if (gem.order > dto.order) {
      fromOrder = dto.order;
      toOrder = gem.order;
      diff = 1;
    } else {
      fromOrder = gem.order + 1;
      toOrder = dto.order + 1;
      diff = -1;
    }
    final shiftedGems = await gemRepository.getAllBetweenOrder(fromOrder, toOrder);
    for (final shiftedGem in shiftedGems) {
      shiftedGem.order += diff;
      await gemRepository.save(shiftedGem);
    }
    gem.order = dto.order;
    await gemRepository.save(gem);
    return true;
  }
}