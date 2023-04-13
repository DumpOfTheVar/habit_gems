
import '../../../domain/repository/gem_repository.dart';

class ArchiveGemUseCase {
  ArchiveGemUseCase({required this.gemRepository});

  final GemRepository gemRepository;

  Future<bool> execute(int gemId) async {
    final gem = await gemRepository.getById(gemId);
    if (gem == null) {
      throw Exception('Failed to find gem with id: ' + gemId.toString());
    }
    gem.isActive = !gem.isActive;
    await gemRepository.save(gem);
    return true;
  }
}