import 'package:intl/intl.dart';
import 'dto/create_owned_gem_dto.dart';
import '../../../domain/entity/owned_gem.dart';
import '../../../domain/repository/owned_gem_repository.dart';

class CreateOwnedGemUseCase {
  final OwnedGemRepository repository;

  CreateOwnedGemUseCase({required this.repository});

  Future<bool> execute(CreateOwnedGemDto dto) async {
    final ownedGem = await _makeOwnedGem(dto.gemId);
    await repository.save(ownedGem);
    return true;
  }

  Future<OwnedGem> _makeOwnedGem(int gemId) async {
    final now = DateTime.now();
    final day = await repository.getDay(now);
    return OwnedGem(
      gemId: gemId,
      date: now,
      day: day,
    );
  }
}