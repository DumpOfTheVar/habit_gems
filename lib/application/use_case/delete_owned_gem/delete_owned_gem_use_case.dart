
import 'dto/delete_owned_gem_dto.dart';
import '../../../domain/repository/owned_gem_repository.dart';

class DeleteOwnedGemUseCase {
  final OwnedGemRepository repository;

  DeleteOwnedGemUseCase({required this.repository});

  Future<bool> execute(DeleteOwnedGemDto dto) async {
    final ownedGem = await repository.getLastByGemId(dto.gemId);
    if (ownedGem == null) {
      return false;
    }
    await repository.deleteById(ownedGem.id!);
    return true;
  }
}