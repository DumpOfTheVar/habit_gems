
import 'dto/update_gem_dto.dart';
import '../../../domain/entity/gem.dart';
import '../../../domain/repository/gem_repository.dart';

class UpdateGemUseCase {
  UpdateGemUseCase({required this.gemRepository});

  final GemRepository gemRepository;

  Future<bool> execute(UpdateGemDto dto) async {
    final gem = await gemRepository.getById(dto.id);
    if (gem == null) {
      throw Exception('Failed to find gem with id: ' + dto.id.toString());
    }
    gem.iconId = dto.iconId;
    gem.title = dto.title;
    gem.trigger = dto.trigger;
    gem.description = dto.description;
    gem.goalCount = dto.goalCount;
    gem.goalPeriod = GoalPeriod.fromDays(dto.goalPeriod);
    gem.isActive = dto.isActive;
    await gemRepository.save(gem);
    return true;
  }
}