import 'dto/create_gem_dto.dart';
import '../../../domain/entity/gem.dart';
import '../../../domain/repository/gem_repository.dart';

class CreateGemUseCase {
  CreateGemUseCase({required this.gemRepository});

  final GemRepository gemRepository;

  Future<bool> execute(CreateGemDto dto) async {
    final maxOrder = await gemRepository.getMaxOrder();
    final gem = Gem(
      iconId: dto.iconId,
      title: dto.title,
      trigger: dto.trigger,
      description: dto.description,
      goalCount: dto.goalCount,
      goalPeriod: GoalPeriod.fromDays(dto.goalPeriod),
      order: maxOrder + 1,
      isActive: true,
    );
    await gemRepository.save(gem);
    return true;
  }
}