import 'dto/delete_gem_dto.dart';
import '../../../domain/repository/gem_repository.dart';
import '../../../domain/repository/owned_gem_repository.dart';

class DeleteGemUseCase {
  DeleteGemUseCase({
    required this.gemRepository,
    required this.ownedGemRepository,
  });

  final GemRepository gemRepository;
  final OwnedGemRepository ownedGemRepository;

  Future<bool> execute(DeleteGemDto dto) async {
    await ownedGemRepository.deleteAllByGemId(dto.gemId);
    await gemRepository.deleteById(dto.gemId);
    return true;
  }
}